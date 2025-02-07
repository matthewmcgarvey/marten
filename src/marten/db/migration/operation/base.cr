require "../../concerns/can_format_strings_or_symbols"

module Marten
  module DB
    abstract class Migration
      module Operation
        abstract class Base
          include CanFormatStringsOrSymbols

          @faked = false

          setter faked

          abstract def describe : String

          abstract def mutate_db_backward(
            app_label : String,
            schema_editor : Management::SchemaEditor::Base,
            from_state : Management::ProjectState,
            to_state : Management::ProjectState
          ) : Nil

          abstract def mutate_db_forward(
            app_label : String,
            schema_editor : Management::SchemaEditor::Base,
            from_state : Management::ProjectState,
            to_state : Management::ProjectState
          ) : Nil

          abstract def mutate_state_forward(app_label : String, state : Management::ProjectState) : Nil

          abstract def serialize : String

          def faked? : Bool
            @faked
          end
        end
      end
    end
  end
end
