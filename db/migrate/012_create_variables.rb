require 'db/migration_helpers'

class CreateVariables < ActiveRecord::Migration
  extend MigrationHelpers

  def self.up
    create_table :variables do |t|
      t.string :var
      t.string :item
      t.integer :row
      t.integer :col
      t.integer :survey_id
      t.integer :question_id      
      t.timestamps
      t.string :datatype

      t.index :survey_id
      t.index :question_id
    end
    add_foreign_key('variables', 'fk_variables_surveys', 'survey_id', 'surveys', 'id')
    add_foreign_key('variables', 'fk_variables_questions', 'question_id', 'questions', 'id')
  end

  def self.down
    drop_table :variables
  end
end
