class AddDeltaIndex < ActiveRecord::Migration
  def self.up
    add_column :groups, :delta, :boolean, :default => true, :null => false
    add_index :groups, :delta
    add_index :groups, :code
  end

  def self.down
    remove_index :groups, :code
    remove_index :groups, :delta
    remove_column :groups, :delta
  end
end
