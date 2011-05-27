class AddIndexes < ActiveRecord::Migration
  def self.up
      add_index :groups, :center_id
      add_index :survey_answers, :journal_entry_id
      add_index :journal_entries, :journal_id
      add_index :journal_entries, :survey_id
      add_index :journal_entries, :survey_answer_id
    end

    def self.down
      remove_index :groups, :center_id
      remove_index :survey_answers, :journal_entry_id
      remove_index :journal_entries, :journal_id
      remove_index :journal_entries, :survey_id
      remove_index :journal_entries, :survey_answer_id
    end
end
