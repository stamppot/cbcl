class CreateCsvSurveyAnswer < ActiveRecord::Migration
  def self.up
    create_table :csv_survey_answers, :force => true do |t|
      t.integer :journal_id, :survey_answer_id, :survey_id, :journal_entry_id, :journal_id, :team_id, :center_id
      t.integer :age, :sex
      t.text :answer, :variables
      # t.string :header , :journal_info
      t.timestamps
    end
    add_index :csv_score_rapports, :survey_answer_id, :unique => true
    add_index :csv_score_rapports, :center_id
    add_index :csv_score_rapports, :team_id
    add_index :csv_score_rapports, :age    
  end

  def self.down
    drop_table :csv_score_rapports
  end
end