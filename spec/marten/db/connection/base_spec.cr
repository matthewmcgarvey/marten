require "./spec_helper"

describe Marten::DB::Connection::Base do
  describe "::new" do
    it "initializes the DB as expected" do
      Marten.settings.databases.each do |config|
        conn = Marten::DB::Connection.get(config.id)

        expected_db_uri = URI.new(
          scheme: conn.scheme,
          user: config.user,
          password: config.password,
          host: config.host,
          port: config.port,
          path: (config.name || "").gsub(":memory:", ""),
          query: URI::Params.build do |params|
            params.add("checkout_timeout", config.checkout_timeout.to_s)
            params.add("initial_pool_size", config.initial_pool_size.to_s)
            params.add("max_idle_pool_size", config.max_idle_pool_size.to_s)
            params.add("max_pool_size", config.max_pool_size.to_s)
            params.add("retry_attempts", config.retry_attempts.to_s)
            params.add("retry_delay", config.retry_delay.to_s)
          end
        ).to_s

        conn.open do |db_conn|
          db_conn.context.uri.to_s.should eq expected_db_uri
        end
      end
    end
  end

  describe "#alias" do
    it "returns the alias associated with the connection database" do
      db_config_1 = Marten::Conf::GlobalSettings::Database.new("default")
      db_config_1.backend = "sqlite"
      db_config_1.name = "development.db"

      db_config_2 = Marten::Conf::GlobalSettings::Database.new("other")
      db_config_2.backend = "postgresql"
      db_config_2.name = "localdb"
      db_config_2.user = "postgres"
      db_config_2.password = ""

      conn_1 = Marten::DB::Connection::SQLite.new(db_config_1)
      conn_2 = Marten::DB::Connection::PostgreSQL.new(db_config_2)

      conn_1.alias.should eq "default"
      conn_2.alias.should eq "other"
    end
  end

  describe "#build_sql" do
    it "allows to build a SQL statement" do
      conn = Marten::DB::Connection::SQLite.new(Marten::Conf::GlobalSettings::Database.new("default"))

      sql = conn.build_sql do |s|
        s << "SELECT *"
        s << "FROM my_table"
        s << "WHERE id = 1"
      end

      sql.should eq "SELECT * FROM my_table WHERE id = 1"
    end
  end

  describe "#insert" do
    it "inserts a new record in a specific table and returns nil if the new ID is not requested" do
      conn = Marten::DB::Connection.default

      record_id = conn.insert(
        Tag.db_table,
        values: {"name" => "crystal", "is_active" => true}
      )

      record_id.should be_nil

      conn.open do |db|
        result = db.scalar("SELECT count(id) FROM #{Tag.db_table}")
        result.should eq 1
      end
    end

    it "inserts a new record in a specific table and returns the corresponding ID when requested" do
      conn = Marten::DB::Connection.default

      record_id = conn.insert(
        Tag.db_table,
        values: {"name" => "crystal", "is_active" => true},
        pk_field_to_fetch: "id"
      )

      record_id.should be_truthy

      conn.open do |db|
        result = db.scalar("SELECT count(id) FROM #{Tag.db_table} WHERE id = #{record_id}")
        result.should eq 1
      end
    end
  end

  describe "#open" do
    it "allows to open a DB connection" do
      conn = Marten::DB::Connection.default

      conn.open do |db|
        result = db.scalar("SELECT 1")
        result.should eq 1
      end
    end

    it "reuses any already opened transaction" do
      conn = Marten::DB::Connection.default

      conn.transaction do
        conn.open do |db|
          db.should be_a(DB::Connection)
        end
      end
    end
  end

  describe "#sanitize_like_pattern" do
    it "properly escapes % characters" do
      conn = Marten::DB::Connection.default
      conn.sanitize_like_pattern("test%foo").should eq "test\\%foo"
    end

    it "properly escapes _ characters" do
      conn = Marten::DB::Connection.default
      conn.sanitize_like_pattern("test_foo").should eq "test\\_foo"
    end
  end

  describe "#transaction" do
    it "wraps DB operations in a transaction" do
      conn = Marten::DB::Connection.default

      TestUser.connection.should eq conn

      expect_raises Exception, "Unexpected" do
        conn.transaction do
          TestUser.create!(username: "jd1", email: "jd@example.com", first_name: "John", last_name: "Doe")
          raise "Unexpected error"
          TestUser.create!(username: "jd2", email: "jd@example.com", first_name: "Jil", last_name: "Dan")
        end
      end

      TestUser.all.size.should eq 0
    end
  end

  describe "#test_database?" do
    it "returns true if the connection is associated with a test database" do
      db_config = Marten::Conf::GlobalSettings::Database.new("default")
      db_config.with_target_env(Marten::Conf::Env::TEST) do |c|
        c.name = "test_db"
      end
      conn = Marten::DB::Connection::SQLite.new(db_config)
      conn.test_database?.should be_true
    end

    it "returns false if the connection is not associated with a test database" do
      db_config = Marten::Conf::GlobalSettings::Database.new("default")
      db_config.with_target_env("production") do |c|
        c.name = "production_db"
      end
      conn = Marten::DB::Connection::SQLite.new(db_config)
      conn.test_database?.should be_false
    end
  end

  describe "#update" do
    it "updates an existing record in a specific table" do
      conn = Marten::DB::Connection.default

      record_id = conn.insert(
        Tag.db_table,
        values: {"name" => "crystal", "is_active" => true},
        pk_field_to_fetch: "id"
      )

      record_id = conn.update(
        Tag.db_table,
        values: {"name" => "ruby"},
        pk_column_name: "id",
        pk_value: record_id
      )

      record_id.should be_nil

      conn.open do |db|
        result = db.scalar("SELECT count(id) FROM #{Tag.db_table} WHERE name = 'ruby'")
        result.should eq 1
      end
    end
  end
end
