class AddLetterFollowUp < ActiveRecord::Migration
  def self.up
    add_column :letters, :follow_up, :int
  end

  def self.down
    remove_column :letters, :follow_up
  end
end