class EntryReminderStatus < ActiveRecord::Migration
  def self.up
    add_column :journal_entries, :reminder_status, :integer
  end

  def self.down
    remove_column :journal_entries, :reminder_status
  end
end