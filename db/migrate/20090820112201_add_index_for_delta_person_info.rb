class AddIndexForDeltaPersonInfo < ActiveRecord::Migration
  def self.up
    add_column :person_infos, :delta, :boolean, :default => true, :null => false
    add_index :person_infos, :delta
  end

  def self.down
    add_column :person_infos, :delta
    remove_index :person_infos, :delta
  end
end
