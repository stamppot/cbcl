class CreateCsvAnswers < ActiveRecord::Migration
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
  end

  def self.down
    remove_index :csv_answers, :journal_id
    remove_index :csv_answers, :survey_id
    drop_table :csv_answers
  end
end
