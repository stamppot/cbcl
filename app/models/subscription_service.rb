class SubscriptionService

  attr_accessor :center

  def initialize(center)
    @center = center
  end

  def update_subscriptions(surveys)
    subscriptions = Subscription.for_center(@center)
    subscriptions.each do |sub|
      if surveys.include? sub.survey_id.to_s   # in survey and in db
        sub.activate!
      else   # not in surveys, but in db, so deactivate
        sub.deactivate!
      end
      surveys.delete sub.survey_id.to_s   # remove already done subs
    end
    # elsif not exists in db, create new subscription
    surveys.each do |survey|
      sub = Subscription.new
      sub.state = 1
      sub.survey_id = survey
      sub.center = @center
      @center.subscriptions << sub
    end

  rescue ActiveRecord::RecordNotFound
    surveys.each do |survey|
      @center.subscriptions << Subscription.new(self, survey, 1)
    end
  end

  # finds all periods for all subscriptions
  def subscription_summary(options = {})
    periods = Query.new.query_subscription_periods_for_centers(@center.id)
    periods.group_by {|c| c["created_on"] }
  end
  
  # set active periods to paid. Create new periods  
  def pay_active_subscriptions!
    @center.subscriptions.all { |sub| sub.pay! }
  end
  
  def undo_pay_subscriptions!
    @center.subscriptions.each { |sub| sub.undo_pay! }
  end
  
  def set_same_date_on_subscriptions!
    first_period = self.subscriptions.map {|s| s.periods}.flatten.sort_by(&:created_on).first
    @center.subscriptions.each do |sub|
      sub.periods.each { |p| p.created_on = first_period.created_on; p.save }
    end
  end
  

end