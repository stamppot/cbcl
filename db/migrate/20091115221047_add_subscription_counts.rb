class AddSubscriptionCounts < ActiveRecord::Migration
  def self.up
    add_column :subscriptions, :total_used, :int
    add_column :subscriptions, :total_paid, :int
    add_column :subscriptions, :active_used, :int
    add_column :subscriptions, :most_recent_payment, :date
    
    subs = Subscription.all(:include => :copies)
    subs.each do |sub|
      sub.total_used = sub.periods_used
      # sub.total_paid = sub.active_copies_used
      last_paid = sub.periods.reverse.detect(&:consolidated_on)
      sub.most_recent_payment = last_paid.consolidated_on if last_paid
      sub.active_used = sub.active_periods_used
      sub.save
    end
  end

  def self.down
    remove_column :subscriptions, :active_used
    remove_column :subscriptions, :most_recent_payment
    remove_column :subscriptions, :total_used
    remove_column :subscriptions, :total_paid
  end
end
