class SubscriptionPresenter

  # Details view: subscription (one per survey), list of total, total_active (since last payment)
  # Summary view: periods
  # periods -> total used in period 
  attr_accessor :group, :subscriptions, :summary_view, :surveys, :periods, :detailed_view, :total_periods, :params

  def initialize(group, surveys = nil, subscriptions = nil, params = {}) # for a group
    subscriptions ||= group.subscriptions(:include => :periods)
    surveys ||= group.surveys
    @group = group
    @params = params
    @detailed_view = [] #{}
    @summary_view = {:periods => [], :total_periods => 0}
    @subscriptions = subscriptions.sort_by { |s| s.survey_id }
    @surveys = surveys.to_hash_with_key { |s| s.id }
    self.periods_summary
    self.details
    self
  end
  
  # survey.title -> counts total, active per subscription (now in dbtable subscriptions)
  # counts total for all subscriptions
  def detail(subscription)
    active_count = subscription.find_active_period.used
    survey = @surveys[subscription.survey_id]
    @detailed_view << {
      :subscription => subscription,
      :title => (survey && survey.title || "Ingen titel"),
      :total => subscription.total_used,
      :note => subscription.note || "",
      :active => subscription.active_used,
      :paid => subscription.total_paid,
      :state => Subscription.states.invert[subscription.state],
      :start => subscription.created_at
    }
  end

  def details # details for all subscriptions
    @subscriptions.each { |subscription| detail(subscription) }
    @detailed_view
  end

  # totals for all subscriptions
  def total_paid
    @group.subscriptions.sum { |s| s.total_paid }
  end

  def total_used
    @group.subscriptions.sum { |s| s.total_used }
  end

  def total_unpaid
    @group.subscriptions.sum { |s| s.active_used }
  end

  def periods_summary # count totals in periods
    summaries = @group.subscription_service.subscription_summary(@params).sort_by {|s| s.first }
    summaries.each do |summary|
      date, periods = *summary
      used = periods.sum {|p| p["used"].to_i }
      active = periods.sum {|p| p["active_used"].to_i }
      is_paid = periods.all? { |p| p['paid'].to_i > 0 && p['paid_on']}
      paid_on = periods.detect { |p| p['paid_on'] }
      paid_on &&= paid_on['paid_on']
      stopped_on = periods.first["paid_on"]
      @summary_view[:periods] << {
        :start_on => date, 
        :used => used,
        :active => active,
        :paid => is_paid,
        :created => date,
        :stopped_on => stopped_on,
        :paid_on => paid_on
      }  
      @summary_view[:total_periods] += used  
    end
  end
       
end