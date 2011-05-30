require 'db/migration_helpers'

class CreateCsvAnswers < ActiveRecord::Migration
  extend MigrationHelpers

  def self.up
    create_table :csv_answers, :force => true do |t|
      t.integer :survey_answer_id, :survey_id, :journal_entry_id, :journal_id, :age, :sex
      t.text :answer
      t.string :header
  		t.string :journal_info
  		
      # t.datetime :created_at # timestamp columns shouldn't be there
      t.index :journal_id
      t.index :survey_id
    end
    add_foreign_key('csv_answers', 'fk_csv_answers_survey_answers', 'survey_answer_id', 'survey_answers', 'id')
  end

  def self.down
    drop_table :csv_answers
  end
end
