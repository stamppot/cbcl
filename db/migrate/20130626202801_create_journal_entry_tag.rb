class CreateJournalEntryTag < ActiveRecord::Migration
  def self.up
    add_column :journal_entries, :notes, :string
  end

  def self.down
    remove_column :journal_entries, :notes
  end
end