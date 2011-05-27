class AddUserIndex < ActiveRecord::Migration
  def self.up
    add_index :users, :login_user
  end

  def self.down
		remove_index :users, :login_user
  end
end