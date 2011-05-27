class AddIndexCenterInfo < ActiveRecord::Migration
  def self.up
    add_index :center_infos, :center_id
  end

  def self.down
    remove_index :center_infos, :center_id
  end
end