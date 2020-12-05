module Marten
  module DB
    abstract class Migration
      module Operation
        class RenameColumn < Base
          @table_name : String
          @old_name : String
          @new_name : String

          def initialize(table_name : String | Symbol, old_name : String | Symbol, new_name : String | Symbol)
            @table_name = table_name.to_s
            @old_name = old_name.to_s
            @new_name = new_name.to_s
          end

          def mutate_db_backward(
            app_label : String,
            schema_editor : Management::SchemaEditor::Base,
            from_state : Management::ProjectState,
            to_state : Management::ProjectState
          ) : Nil
            table = from_state.get_table(app_label, @table_name)
            column = table.get_column(@new_name)
            schema_editor.rename_column(table, column, @old_name)
          end

          def mutate_db_forward(
            app_label : String,
            schema_editor : Management::SchemaEditor::Base,
            from_state : Management::ProjectState,
            to_state : Management::ProjectState
          ) : Nil
            table = from_state.get_table(app_label, @table_name)
            column = table.get_column(@old_name)
            schema_editor.rename_column(table, column, @new_name)
          end

          def mutate_state_forward(app_label : String, state : Management::ProjectState) : Nil
            table = state.get_table(app_label, @table_name)
            table.rename_column(@old_name, @new_name)
          end
        end
      end
    end
  end
end