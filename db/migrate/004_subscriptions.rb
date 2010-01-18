class Subscriptions < ActiveRecord::Migration
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
      end
      create_table :periods do |t|
          t.column :subscription_id, :int, :null => false
          t.column :used, :int, :null => false, :default => 0
          t.column :paid, :boolean, :default => false  # when is this set of copies paid
          t.column :paid_on, :date
          t.column :created_on, :date   # when this object was created
          t.column :updated_on, :datetime
          t.column :active, :boolean, :null => false, :default => false
      end
      add_index :subscriptions, :center_id
      subs = Subscription.all(:include => :periods)
      subs.each do |sub|
        sub.total_used = sub.periods_used
        last_paid = sub.periods.reverse.detect(&:paid_on)
        sub.total_paid = sub.periods.paid.sum(:used)
        sub.most_recent_payment = last_paid.paid_on if last_paid
        sub.active_used = sub.active_periods_used
        sub.save
      end
  end

  def self.down
    remove_index :subscriptions, :center_id
    drop_table :periods
    drop_table :subscriptions
  end
end
