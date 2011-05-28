require 'db/migration_helpers'

class SurveyAnswers < ActiveRecord::Migration
  extend MigrationHelpers

  def self.up
    create_table :survey_answers do |t|   # has_many answers
      t.column :survey_id, :int, :null => false
      t.column :surveytype, :string, :limit => 15
      t.column :answered_by, :string, :limit => 100
      t.column :age, :int, :null => false
      t.column :sex, :int, :null => false
      t.column :nationality, :string, :limit => 40
      t.column :journal_entry_id, :int, :null => false
      t.column :done, :boolean, :default => false
      t.column :journal_id, :integer    
      t.column :center_id, :integer
      t.datestamps # when answer was done
      t.index  :journal_id
      t.index  :center_id
      t.index  :survey_id
      t.index  :journal_entry_id
      t.index  :age
      t.index  :done
    end
    add_foreign_key('survey_answers', 'fk_survey_answers_journals', 'journal_id', 'groups', 'id')
    add_foreign_key('survey_answers', 'fk_survey_answers_surveys', 'survey_id', 'surveys', 'id')
    add_foreign_key('survey_answers', 'fk_survey_answers_centers', 'center_id', 'groups', 'id')
    add_foreign_key('survey_answers', 'fk_survey_answers_journal_entry', 'journal_entry_id', 'journal_entries', 'id')
    
    create_table :answers do |t|
      t.column :survey_answer_id, :int, :null => false
      t.column :number, :int, :null => false   # question no. the answer applies to
      t.column :question_id, :int, :null => false
      t.column :ratings_count, :int # answered ratings count
      t.index  :question_id
      t.index  :survey_answer_id
    end
    add_foreign_key('answers', 'fk_answers_survey_answers', 'survey_answer_id', 'survey_answers', 'id')
    add_foreign_key('answers', 'fk_answers_questions', 'question_id', 'questions', 'id')
    
    create_table :answer_cells, :force => true do |t|
      t.integer :answer_id,               :default => 0, :null => false
      t.integer :col,                     :default => 0, :null => false
      t.integer :row,                     :default => 0, :null => false
      t.string  :item,       :limit => 5
      t.boolean :rating
      t.string  :value_text
      t.boolean :text
      t.integer :cell_type
      t.integer :value
    end
    add_foreign_key('answer_cells', 'fk_answer_cells_answers', 'answer_id', 'answers', 'id')
    add_index :answers, :survey_answer_id
    add_index :answer_cells, :answer_id
    add_index :answers, :number
    add_index :answer_cells, :row
  end

  def self.down
    drop_table :answer_cells
    drop_table :answers
    drop_table :survey_answers
  end
end
