class AddIndexForDeltas < ActiveRecord::Migration
  def self.up
    add_index :groups, :delta
    add_index :groups, :code
  end

  def self.down
    remove_index :groups, :code
    remove_index :groups, :delta
  end
end
