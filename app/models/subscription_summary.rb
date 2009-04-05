# a non-AR class to summarize subscriptions of a center
class SubscriptionSummary
  
  attr_accessor :copies
  
  
  def initialize(subscriptions = [])
    # go thru all subscriptions' copies and divide them into time periods
    active = []
    
    copies = subscriptions.map { |sub| sub.copies }.flatten
    @copies = copies.group_by { |c| c.created_on }
    
  end
  
end