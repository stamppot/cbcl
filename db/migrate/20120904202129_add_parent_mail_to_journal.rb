class AddParentMailToJournal < ActiveRecord::Migration
  def self.up
    add_column :person_infos, :parent_email, :string
  end

  def self.down
    remove_column :person_infos, :parent_email
  end
end