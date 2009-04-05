class Subscriptions < ActiveRecord::Migration
  def self.up
      create_table :subscriptions do |t|
        t.column :center_id, :int, :null => false
        t.column :survey_id, :int, :null => false
        t.column :created_at, :datetime
        t.column :updated_at, :datetime
        t.column :state, :int, :null => false
        t.column :note, :text
      end
      create_table :copies do |t|
          t.column :subscription_id, :int, :null => false
          t.column :used, :int, :null => false, :default => 0
          t.column :consolidated, :boolean, :default => false  # when is this set of copies paid
          t.column :consolidated_on, :date
          t.column :created_on, :date   # when this object was created
          t.column :updated_on, :datetime
          t.column :active, :boolean, :null => false, :default => false
      end
      add_index :subscriptions, :center_id
  end

  def self.down
    remove_index :subscriptions, :center_id
    drop_table :copies
    drop_table :subscriptions
  end
end
