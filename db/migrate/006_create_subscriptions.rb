require 'db/migration_helpers'

class CreateSubscriptions < ActiveRecord::Migration
  extend MigrationHelpers
  def self.up
    create_table :subscriptions do |t|
      t.column :center_id, :int, :null => false
      t.column :survey_id, :int, :null => false
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
      t.column :state, :int, :null => false
      t.column :note, :text
      t.column :total_used, :int
      t.column :total_paid, :int
      t.column :active_used, :int
      t.column :most_recent_payment, :date
      t.index :center_id
      t.index :survey_id
    end
    add_foreign_key('subscriptions', 'fk_subscriptions_centers', 'center_id', 'groups', 'id')
    add_foreign_key('subscriptions', 'fk_subscriptions_surveys', 'survey_id', 'surveys', 'id')

    create_table :periods do |t|
      t.column :subscription_id, :int, :null => false
      t.column :used, :int, :null => false, :default => 0
      t.column :paid, :boolean, :default => false  # when is this set of copies paid
      t.column :paid_on, :date
      t.column :created_on, :date   # when this object was created
      t.column :updated_on, :datetime
      t.column :active, :boolean, :null => false, :default => false
      t.index :subscription_id
      t.index :active
      t.index :paid
    end
    add_foreign_key('periods', 'fk_periods_subscriptions', 'subscription_id', 'subscriptions', 'id')
    
    
    # puts "Creating table 'copies' - obsoleted?"
    # create_table "copies", :force => true do |t|
    #   t.integer  "subscription_id", :default => 0,     :null => false
    #   t.integer  "used",            :default => 0,     :null => false
    #   t.boolean  "consolidated",    :default => false
    #   t.date     "consolidated_on"
    #   t.date     "created_on"
    #   t.datetime "updated_on"
    #   t.boolean  "active",          :default => false, :null => false
    # end
  end

  def self.down
    # drop_table :copies
    drop_table :periods
    drop_table :subscriptions
  end
end
