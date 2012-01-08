class CreateCsvSurveyAnswer < ActiveRecord::Migration
  def self.up
    create_table :csv_survey_answers, :force => true do |t|
      t.integer :journal_id, :survey_answer_id, :survey_id, :journal_entry_id, :journal_id, :team_id, :center_id
      t.integer :age, :sex
      t.text :answer, :variables
      t.string :header, :journal_info
      t.timestamps
    end
    add_index :csv_survey_answers, :survey_answer_id, :unique => true
    add_index :csv_survey_answers, :center_id
    add_index :csv_survey_answers, :team_id
    add_index :csv_survey_answers, :age
    
                
    create_table :journal_infos, :force => true do |t|
      t.integer :journal_id, :center_id, :team_id, :pkoen, :palder
      t.string :ssghafd, :ssghnavn, :safdnavn, :pid, :pnation
      t.date :dagsdato, :pfoedt
    end
    add_index :journal_infos, :journal_id, :unique => true
    add_index :journal_infos, :center_id
    add_index :journal_infos, :team_id
  end

  def self.down
    drop_table :journal_infos
    drop_table :csv_survey_answers
  end
end