class AddUserDelta < ActiveRecord::Migration
  def self.up
		add_column :users, :delta, :integer
  end

  def self.down
		remove_column :users, :delta
  end
end