require 'test_helper'

class SubscriptionTest < ActiveSupport::TestCase

	test "subscriptions" do 
		center = groups(:regionnord)
		assert center
		assert center.subscriptions.size > 0
		center.subscriptions.each do |sub|
			assert sub.active?
		end
	end
		
	test "pay subscription" do 
		subscription = subscriptions(:subscription_1)
		assert subscription.active?
		assert_equal 1441, subscription.total_used
		assert_equal 1232, subscription.total_paid
		assert_equal 212, subscription.active_used
		assert_equal 2, subscription.periods.count

		assert !subscription.periods[0].active?
		assert subscription.periods[1].active?
		
		# pay
		subscription.pay!
		# periods are updated
		assert_equal 3, subscription.periods.count
		assert !subscription.periods[0].active?
		assert !subscription.periods[1].active?
		assert subscription.periods[2].active?
		old_period = subscription.periods[1]
		new_period = subscription.periods[2]
		
		assert_equal 0, new_period.used
		assert !new_period.paid
		puts "new period: #{new_period.inspect}"
		puts "old period: #{subscription.periods[1].inspect}"
		assert subscription.periods[1].paid_on
		# subscription is updated
		assert_equal 1441, subscription.total_used
		assert_equal 1441, subscription.total_paid
		assert_equal 0, subscription.active_used
		assert_equal Date.today, subscription.most_recent_payment
	end

	
	# def test_pay_subscription
	# 	
	# end
	
	def test_pay_subscriptions_for_center
		
	end
	
	
	
	
	
	
	
	
	
	
end