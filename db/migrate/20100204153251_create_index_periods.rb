class CreateIndexPeriods < ActiveRecord::Migration
  def self.up
    add_index :periods, :subscription_id
  end

  def self.down
    remove_index :periods, :subscription_id
  end
end
