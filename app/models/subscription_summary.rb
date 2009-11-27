# a non-AR class to summarize subscriptions of a center
class SubscriptionSummary
  
  attr_accessor :periods
  
  
  def initialize(subscriptions = [])
    # go thru all subscriptions' copies and divide them into time periods
    active = []
    
    periods = subscriptions.map { |sub| sub.periods }.flatten
    @periods = periods.group_by { |c| c.created_on }
    
  end
  
end