class SurveyAnswers < ActiveRecord::Migration
  def self.up
    create_table :survey_answers do |t|   # has_many answers
      t.column :survey_id, :int, :null => false
      t.column :surveytype, :string, :limit => 15
      t.column :answered_by, :string, :limit => 15
      t.column :created_at, :datetime     # when answer was done
      t.column :age, :int, :null => false
      t.column :sex, :int, :null => false
      t.column :nationality, :string, :limit => 24
      t.column :journal_entry_id, :int, :null => false
      t.column :done, :boolean, :default => false
      t.column :updated_at, :datetime
      t.column :journal_id, :integer    
      t.index  :journal_id
      t.column :center_id, :integer
    end
    create_table :answers do |t|          # answers has_many answer_cells
      t.column :survey_answer_id, :int, :null => false
      t.column :number, :int, :null => false   # question no. the answer applies to
      t.column :question_id, :int, :null => false
    end
    create_table :answer_cells do |t|     # belongs_to answers
      t.column :answer_id, :int, :null => false
      t.column :answertype, :string, :limit => 20
      t.column :col, :int, :null => false
      t.column :row, :int, :null => false
      t.column :item, :string, :limit => 5
      t.column :value, :string
    end
    add_index :answers, :survey_answer_id
    add_index :answer_cells, :answer_id
    add_index :answers, :number
    add_index :answer_cells, :row
  end

  def self.down
    remove_index :answers, :survey_answer_id
    remove_index :answer_cells, :answer_id
    drop_table :survey_answers
    drop_table :answers
    drop_table :answer_cells
  end
end
