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
  
  # input: group / all subscriptions for a group

  def periods # needs list of periods for all subscriptions
    
  end

  # survey.title -> counts total, active per subscription (now in dbtable subscriptions)
  # counts total for all subscriptions
  def detail(subscription)
    active_count = subscription.find_active_period.used
    # puts "active_count: #{active_count}"
    # puts "total: #{subscription.total_used}"
    survey = @surveys[subscription.survey_id]
    # @detailed_view[subscription.id] = {
    @detailed_view << {
      :subscription => subscription,
      :title => (survey && survey.title || "Ingen titel"),
      :total => subscription.total_used,
      :note => subscription.note || "",
      :active => subscription.active_used, #active_count,
      :paid => subscription.total_paid, # (subscription.total_used.to_i - active_count.to_i),
      :state => Subscription.states.invert[subscription.state],
      :start => subscription.created_at#,
      # :survey => @surveys[subscription.survey_id]
    }
    # @summary_view[:total_paid] = total_paid
    # @summary_view[:total_used] = total_used
    # @summary_view[:total_unpaid] = total_unpaid
  end

  def details # details for all subscriptions
    @subscriptions.each { |subscription| detail(subscription) }
    @detailed_view
  end

  # totals for all subscriptions
  def total_paid
    @group.subscriptions.map { |s| s.total_paid }.sum
  end

  def total_used
    @group.subscriptions.map { |s| s.total_used }.sum
  end

  def total_unpaid
    @group.subscriptions.map { |s| s.active_used }.sum
  end

  def periods_summary # count totals in periods
    sub_service = SubscriptionService.new(@group)
    summaries = sub_service.subscription_summary(@params).sort_by {|s| s.first }
    # summaries = @group.subscription_summary(@params).sort_by {|s| s.first }
    summaries.each do |summary|
      date, periods = *summary
      used = periods.inject(0) {|n, p| n + p["used"].to_i }
      active = periods.inject(0) {|n, p| n + p["active_used"].to_i }
      total = periods.inject(0) {|n, p| n + p["total_used"].to_i }
      paid = periods.all? { |p| p['paid'].to_i > 0 && p['paid_on']} # inject(0) {|n, p| n + p["paid"].to_i }
      paid_on = periods.detect { |p| p['paid_on'] }
      paid_on &&= paid_on['paid_on']
      stopped_on = periods.first["paid_on"] #detect { |p| p["paid_on"] }.inspect
      @summary_view[:periods] << {
        :start_on => date, 
        :used => used,
        :active => active,
        :paid => paid, # are all subscriptions paid in this period
        :total_used => used,
        :created => date,
        :stopped_on => stopped_on,
        :paid_on => paid_on
      }    
    end
  end
       
end