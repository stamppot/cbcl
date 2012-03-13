class CreateCsvSurveyAnswer < ActiveRecord::Migration
  def self.up
    create_table :csv_survey_answers, :force => true do |t|
      t.integer :journal_id, :survey_answer_id, :survey_id, :journal_entry_id, :journal_id, :team_id, :center_id
      t.integer :age, :sex
      t.text :answer, :variables
      # t.string :header , :journal_info
      t.timestamps
    end
  end

  def self.down
    drop_table :csv_score_rapports
  end
end