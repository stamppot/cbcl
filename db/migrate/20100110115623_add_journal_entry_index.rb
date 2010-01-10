class AddJournalEntryIndex < ActiveRecord::Migration
  def self.up
    add_index :journal_entries, :user_id
  end

  def self.down
    remove_index :journal_entries, :user_id
  end
end
