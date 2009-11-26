require 'models/subscription'
require 'models/period'
class AddSubscriptionCounts < ActiveRecord::Migration
  def self.up
    # add_column :subscriptions, :total_used, :int
    # add_column :subscriptions, :total_paid, :int
    # add_column :subscriptions, :active_used, :int
    # add_column :subscriptions, :most_recent_payment, :date
    # rename_column :copies, :consolidated_on, :paid_on
    # rename_column :copies, :consolidated, :paid
    # rename_table :copies, :periods
    subs = Subscription.all(:include => :periods)
    # subs = Subscription.all(:include => :copies)
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
    rename_column :copies, :paid, :consolidated
    rename_table :periods, :copies
    rename_column :copies, :paid_on, :consolidated_on
    remove_column :subscriptions, :active_used
    remove_column :subscriptions, :most_recent_payment
    remove_column :subscriptions, :total_used
    remove_column :subscriptions, :total_paid
  end
end
