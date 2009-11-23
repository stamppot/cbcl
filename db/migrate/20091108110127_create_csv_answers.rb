class CreateCsvAnswers < ActiveRecord::Migration
  def self.up
    create_table :csv_answers, :force => true do |t|
      t.integer :survey_answer_id, :survey_id, :journal_entry_id, :journal_id, :age, :sex
      t.text :answer
      t.datetime :created_at
    end
    add_index :csv_answers, :journal_id
    add_index :csv_answers, :survey_id
    
    # fill table
    CSVHelper.new.generate_csv_answers
  end

  def self.down
    remove_index :csv_answers, :journal_id
    remove_index :csv_answers, :survey_id
    drop_table :csv_answers
  end
end
