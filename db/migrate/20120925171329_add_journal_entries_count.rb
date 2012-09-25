class AddJournalEntriesCount < ActiveRecord::Migration
  def self.up
    add_column :journal_entries, :follow_up, :int
  end

  def self.down
    remove_column :journal_entries, :follow_up
  end
end