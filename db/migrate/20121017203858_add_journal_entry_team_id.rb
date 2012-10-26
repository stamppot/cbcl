class AddJournalEntryTeamId < ActiveRecord::Migration
  def self.up
    add_column :journal_entries, :group_id, :int
    add_index :journal_entries, :group_id
  end

  def self.down
    remove_index :journal_entries, :group_id
    remove_column :journal_entries, :group_id
  end
  
  def self.update
    JournalEntry.find_each() do |entry|
      entry.group_id = entry.journal.parent_id
      entry.save
    end
  end
  
end