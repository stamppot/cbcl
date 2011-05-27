class AddIndexGroups < ActiveRecord::Migration
  def self.up
    add_index :groups, :type
    add_index :groups, :parent_id
  end

  def self.down
		remove_index :groups, :parent_id
		remove_index :groups, :type
  end
end