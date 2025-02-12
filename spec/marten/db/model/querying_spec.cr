require "./spec_helper"

describe Marten::DB::Model::Querying do
  describe "::all" do
    it "returns a queryset containing all the objects matched by the default scope" do
      TestUser.create!(username: "jd1", email: "jd@example.com", first_name: "John", last_name: "Doe")
      TestUser.create!(username: "foo", email: "fb@example.com", first_name: "Foo", last_name: "Bar")

      qs = TestUser.all
      qs.should be_a(Marten::DB::Query::Set(TestUser))

      results = qs.to_a
      results.size.should eq 2
      results.includes?(TestUser.get!(username: "jd1")).should be_true
      results.includes?(TestUser.get!(username: "foo")).should be_true
    end

    it "returns a queryset containing all the objects matched by a custom default scope if applicable" do
      Tag.create!(name: "crystal", is_active: true)
      Tag.create!(name: "ruby", is_active: false)
      Tag.create!(name: "coding", is_active: true)

      qs = Tag.all
      qs.should be_a(Marten::DB::Query::Set(Tag))

      results = qs.to_a
      results.size.should eq 2
      results.includes?(Tag.get!(name: "crystal")).should be_true
      results.includes?(Tag.get!(name: "coding")).should be_true
    end
  end

  describe "::default_queryset" do
    it "returns a queryset containing all the objects by default" do
      TestUser.create!(username: "jd1", email: "jd@example.com", first_name: "John", last_name: "Doe")
      TestUser.create!(username: "foo", email: "fb@example.com", first_name: "Foo", last_name: "Bar")

      qs = TestUser.default_queryset
      qs.should be_a(Marten::DB::Query::Set(TestUser))

      results = qs.to_a
      results.size.should eq 2
      results.includes?(TestUser.get!(username: "jd1")).should be_true
      results.includes?(TestUser.get!(username: "foo")).should be_true
    end
  end

  describe "::exclude" do
    before_each do
      TestUser.create!(username: "jd1", email: "jd1@example.com", first_name: "John", last_name: "Doe")
      TestUser.create!(username: "jd2", email: "jd2@example.com", first_name: "John", last_name: "Doe")
      TestUser.create!(username: "foo", email: "fb@example.com", first_name: "Foo", last_name: "Bar")

      Tag.create!(name: "crystal", is_active: true)
      Tag.create!(name: "ruby", is_active: false)
      Tag.create!(name: "coding", is_active: true)
    end

    it "returns a queryset without the objects matching the excluding predicates" do
      qs = TestUser.exclude(username: "foo")
      qs.should be_a(Marten::DB::Query::Set(TestUser))

      results = qs.to_a
      results.size.should eq 2
      results.includes?(TestUser.get!(username: "jd1")).should be_true
      results.includes?(TestUser.get!(username: "jd2")).should be_true
    end

    it "makes use of the default queryset" do
      qs = Tag.exclude(name: "coding")
      qs.should be_a(Marten::DB::Query::Set(Tag))

      results = qs.to_a
      results.size.should eq 1
      results[0].should eq Tag.get!(name: "crystal")
    end

    it "returns a queryset without the objects matching the advanced predicates expression" do
      qs = TestUser.exclude { q(username: "foo") | q(username: "jd1") }
      qs.should be_a(Marten::DB::Query::Set(TestUser))

      results = qs.to_a
      results.size.should eq 1
      results[0].should eq TestUser.get(username: "jd2")
    end

    it "makes use of the default queryset when using a block defining an advanced predicates expression" do
      qs = Tag.exclude { q(name: "crystal") | q(name: "coding") }
      qs.should be_a(Marten::DB::Query::Set(Tag))

      results = qs.to_a
      results.size.should eq 0
    end
  end

  describe "::filter" do
    before_each do
      TestUser.create!(username: "jd1", email: "jd1@example.com", first_name: "John", last_name: "Doe")
      TestUser.create!(username: "jd2", email: "jd2@example.com", first_name: "John", last_name: "Doe")
      TestUser.create!(username: "foo", email: "fb@example.com", first_name: "Foo", last_name: "Bar")

      Tag.create!(name: "crystal", is_active: true)
      Tag.create!(name: "ruby", is_active: false)
      Tag.create!(name: "coding", is_active: true)
    end

    it "returns a queryset with the objects matching the filter predicates" do
      qs = TestUser.filter(username__startswith: "jd")
      qs.should be_a(Marten::DB::Query::Set(TestUser))

      results = qs.to_a
      results.size.should eq 2
      results.includes?(TestUser.get!(username: "jd1")).should be_true
      results.includes?(TestUser.get!(username: "jd2")).should be_true
    end

    it "makes use of the default queryset" do
      qs = Tag.filter(name: "coding")
      qs.should be_a(Marten::DB::Query::Set(Tag))

      results = qs.to_a
      results.size.should eq 1
      results[0].should eq Tag.get!(name: "coding")
    end

    it "returns a queryset with the objects matching the advanced predicates expression" do
      qs = TestUser.filter { q(username: "foo") | q(username: "jd1") }
      qs.should be_a(Marten::DB::Query::Set(TestUser))

      results = qs.to_a
      results.size.should eq 2
      results.includes?(TestUser.get!(username: "foo")).should be_true
      results.includes?(TestUser.get!(username: "jd1")).should be_true
    end

    it "makes use of the default queryset when using a block defining an advanced predicates expression" do
      qs = Tag.filter { q(name__startswith: "cr") & q(name__endswith: "al") }
      qs.should be_a(Marten::DB::Query::Set(Tag))

      results = qs.to_a
      results.size.should eq 1
      results[0].should eq Tag.get!(name: "crystal")
    end
  end

  describe "::first" do
    before_each do
      TestUser.create!(username: "jd1", email: "jd1@example.com", first_name: "John", last_name: "Doe")
      TestUser.create!(username: "jd2", email: "jd2@example.com", first_name: "John", last_name: "Doe")
      TestUser.create!(username: "foo", email: "fb@example.com", first_name: "Foo", last_name: "Bar")

      Tag.create!(name: "crystal", is_active: false)
      Tag.create!(name: "ruby", is_active: true)
      Tag.create!(name: "coding", is_active: true)
    end

    it "returns the first object" do
      TestUser.first.should eq TestUser.get!(username: "jd1")
    end

    it "makes use of the default queryset" do
      Tag.first.should eq Tag.get!(name: "ruby")
    end
  end

  describe "::first!" do
    before_each do
      TestUser.create!(username: "jd1", email: "jd1@example.com", first_name: "John", last_name: "Doe")
      TestUser.create!(username: "jd2", email: "jd2@example.com", first_name: "John", last_name: "Doe")
      TestUser.create!(username: "foo", email: "fb@example.com", first_name: "Foo", last_name: "Bar")

      Tag.create!(name: "crystal", is_active: false)
      Tag.create!(name: "ruby", is_active: true)
      Tag.create!(name: "coding", is_active: true)
    end

    it "returns the first object" do
      TestUser.first!.should eq TestUser.get!(username: "jd1")
    end

    it "makes use of the default queryset" do
      Tag.first!.should eq Tag.get!(name: "ruby")
    end

    it "raises a NilAssertionError if no record is found" do
      Tag.all.delete
      expect_raises(NilAssertionError) { Tag.first! }
    end
  end

  describe "::get" do
    before_each do
      TestUser.create!(username: "jd1", email: "jd1@example.com", first_name: "John", last_name: "Doe")
      TestUser.create!(username: "jd2", email: "jd2@example.com", first_name: "John", last_name: "Doe")
      TestUser.create!(username: "foo", email: "fb@example.com", first_name: "Foo", last_name: "Bar")

      Tag.create!(name: "crystal", is_active: false)
      Tag.create!(name: "ruby", is_active: true)
      Tag.create!(name: "coding", is_active: true)
    end

    it "returns the object corresponding to the passed simple predicates" do
      user = TestUser.create!(username: "jd3", email: "jd3@example.com", first_name: "John", last_name: "Doe")
      TestUser.get(username: "jd3").should eq user
    end

    it "returns nil if the object does not exist" do
      TestUser.get(username: "unknown").should be_nil
    end

    it "raises if multiple records match the given predicates" do
      expect_raises(Marten::DB::Errors::MultipleRecordsFound) { TestUser.get(username__startswith: "jd") }
    end

    it "makes use of the default queryset" do
      tag = Tag.create!(name: "verbose", is_active: true)
      Tag.get(name: "verbose").should eq tag
      Tag.get(name: "crystal").should be_nil
    end

    it "returns the object matching the advanced predicates" do
      user = TestUser.create!(username: "jd3", email: "jd3@example.com", first_name: "John", last_name: "Doe")
      TestUser.get { q(username__startswith: "jd") & q(username__endswith: "3") }.should eq user
    end

    it "makes use of the default queryset when using a block defining an advanced predicates expression" do
      Tag.get { q(name: "crystal") }.should be_nil
    end
  end

  describe "::get!" do
    before_each do
      TestUser.create!(username: "jd1", email: "jd1@example.com", first_name: "John", last_name: "Doe")
      TestUser.create!(username: "jd2", email: "jd2@example.com", first_name: "John", last_name: "Doe")
      TestUser.create!(username: "foo", email: "fb@example.com", first_name: "Foo", last_name: "Bar")

      Tag.create!(name: "crystal", is_active: false)
      Tag.create!(name: "ruby", is_active: true)
      Tag.create!(name: "coding", is_active: true)
    end

    it "returns the object corresponding to the passed simple predicates" do
      user = TestUser.create!(username: "jd3", email: "jd3@example.com", first_name: "John", last_name: "Doe")
      TestUser.get!(username: "jd3").should eq user
    end

    it "raises if the record is not found" do
      expect_raises(Marten::DB::Errors::RecordNotFound) { TestUser.get!(username: "unknown") }
    end

    it "raises if multiple records match the given predicates" do
      expect_raises(Marten::DB::Errors::MultipleRecordsFound) { TestUser.get!(username__startswith: "jd") }
    end

    it "makes use of the default queryset" do
      tag = Tag.create!(name: "verbose", is_active: true)
      Tag.get!(name: "verbose").should eq tag
      expect_raises(Marten::DB::Errors::RecordNotFound) { Tag.get!(name: "crystal") }
    end

    it "returns the object matching the advanced predicates" do
      user = TestUser.create!(username: "jd3", email: "jd3@example.com", first_name: "John", last_name: "Doe")
      TestUser.get! { q(username__startswith: "jd") & q(username__endswith: "3") }.should eq user
    end

    it "makes use of the default queryset when using a block defining an advanced predicates expression" do
      expect_raises(Marten::DB::Errors::RecordNotFound) { Tag.get! { q(name: "crystal") } }
    end
  end

  describe "::join" do
    it "allows to configure joins for a specific relation" do
      user = TestUser.create!(username: "jd3", email: "jd3@example.com", first_name: "John", last_name: "Doe")
      Post.create!(author: user, title: "Example post")
      Post.join(:author).query.joins?.should be_true
    end
  end

  describe "::last" do
    before_each do
      TestUser.create!(username: "jd1", email: "jd1@example.com", first_name: "John", last_name: "Doe")
      TestUser.create!(username: "jd2", email: "jd2@example.com", first_name: "John", last_name: "Doe")
      TestUser.create!(username: "foo", email: "fb@example.com", first_name: "Foo", last_name: "Bar")

      Tag.create!(name: "ruby", is_active: true)
      Tag.create!(name: "coding", is_active: true)
      Tag.create!(name: "crystal", is_active: false)
    end

    it "returns the last object" do
      TestUser.last.should eq TestUser.get!(username: "foo")
    end

    it "makes use of the default queryset" do
      Tag.last.should eq Tag.get!(name: "coding")
    end
  end

  describe "::last!" do
    before_each do
      TestUser.create!(username: "jd1", email: "jd1@example.com", first_name: "John", last_name: "Doe")
      TestUser.create!(username: "jd2", email: "jd2@example.com", first_name: "John", last_name: "Doe")
      TestUser.create!(username: "foo", email: "fb@example.com", first_name: "Foo", last_name: "Bar")

      Tag.create!(name: "ruby", is_active: true)
      Tag.create!(name: "coding", is_active: true)
      Tag.create!(name: "crystal", is_active: false)
    end

    it "returns the last object" do
      TestUser.last!.should eq TestUser.get!(username: "foo")
    end

    it "makes use of the default queryset" do
      Tag.last!.should eq Tag.get!(name: "coding")
    end

    it "raises a NilAssertionError error if no record is found" do
      Tag.all.delete
      expect_raises(NilAssertionError) { Tag.last! }
    end
  end

  describe "::raw" do
    it "returns the expected records for non-parameterized queries" do
      tag_1 = Tag.create!(name: "ruby", is_active: true)
      tag_2 = Tag.create!(name: "crystal", is_active: true)
      tag_3 = Tag.create!(name: "coding", is_active: true)

      Tag.raw("select * from app_tag order by id;").to_a.should eq [tag_1, tag_2, tag_3]
      Tag.raw("select * from app_tag where name = 'crystal';").to_a.should eq [tag_2]
    end

    it "returns the expected records for queries involving positional parameters" do
      tag_1 = Tag.create!(name: "ruby", is_active: true)
      tag_2 = Tag.create!(name: "crystal", is_active: true)
      tag_3 = Tag.create!(name: "coding", is_active: true)

      Tag.raw("select * from app_tag where name = ?;", ["crystal"]).to_a.should eq [tag_2]
      Tag.raw("select * from app_tag where name = ? or name = ? order by id;", ["ruby", "coding"]).to_a.should eq(
        [tag_1, tag_3]
      )
    end

    it "returns the expected records for queries involving splat positional parameters" do
      tag_1 = Tag.create!(name: "ruby", is_active: true)
      tag_2 = Tag.create!(name: "crystal", is_active: true)
      tag_3 = Tag.create!(name: "coding", is_active: true)

      Tag.raw("select * from app_tag where name = ?;", "crystal").to_a.should eq [tag_2]
      Tag.raw("select * from app_tag where name = ? or name = ? order by id;", "ruby", "coding").to_a.should eq(
        [tag_1, tag_3]
      )
    end

    it "returns the expected records for queries involving named parameters expressed as a named tuple" do
      tag_1 = Tag.create!(name: "ruby", is_active: true)
      tag_2 = Tag.create!(name: "crystal", is_active: true)
      tag_3 = Tag.create!(name: "coding", is_active: true)

      Tag.raw("select * from app_tag where name = :name;", {name: "crystal"}).to_a.should eq [tag_2]
      Tag.raw(
        "select * from app_tag where name = :name1 or name = :name2 order by id;",
        {name1: "ruby", name2: "coding"}
      ).to_a.should eq(
        [tag_1, tag_3]
      )
    end

    it "returns the expected records for queries involving named parameters expressed as a hash" do
      tag_1 = Tag.create!(name: "ruby", is_active: true)
      tag_2 = Tag.create!(name: "crystal", is_active: true)
      tag_3 = Tag.create!(name: "coding", is_active: true)

      Tag.raw("select * from app_tag where name = :name;", {"name" => "crystal"}).to_a.should eq [tag_2]
      Tag.raw(
        "select * from app_tag where name = :name1 or name = :name2 order by id;",
        {"name1" => "ruby", "name2" => "coding"}
      ).to_a.should eq([tag_1, tag_3])
    end

    it "returns the expected records for queries involving double splat named parameters" do
      tag_1 = Tag.create!(name: "ruby", is_active: true)
      tag_2 = Tag.create!(name: "crystal", is_active: true)
      tag_3 = Tag.create!(name: "coding", is_active: true)

      Tag.raw("select * from app_tag where name = :name;", name: "crystal").to_a.should eq [tag_2]
      Tag.raw(
        "select * from app_tag where name = :name1 or name = :name2 order by id;",
        name1: "ruby",
        name2: "coding"
      ).to_a.should eq([tag_1, tag_3])
    end
  end

  describe "::using" do
    before_each do
      TestUser.using(:other).create!(username: "jd1", email: "jd1@example.com", first_name: "John", last_name: "Doe")
      TestUser.using(:other).create!(username: "jd2", email: "jd2@example.com", first_name: "John", last_name: "Doe")
      TestUser.create!(username: "foo", email: "fb@example.com", first_name: "Foo", last_name: "Bar")

      Tag.create!(name: "ruby", is_active: true)
      Tag.using(:other).create!(name: "coding", is_active: true)
      Tag.using(:other).create!(name: "crystal", is_active: false)
    end

    it "returns a default queryset using the specified database" do
      qs1 = TestUser.using(:other)
      results1 = qs1.to_a
      results1.size.should eq 2
      results1.includes?(TestUser.using(:other).get!(username: "jd1")).should be_true
      results1.includes?(TestUser.using(:other).get!(username: "jd1")).should be_true

      qs2 = Tag.using(:other)
      results2 = qs2.to_a
      results2.size.should eq 1
      results2.includes?(Tag.using(:other).get(name: "coding")).should be_true
    end
  end
end
