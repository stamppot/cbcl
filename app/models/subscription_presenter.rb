class SubscriptionPresenter

  # Details view: subscription (one per survey), list of total, total_active (since last payment)
  # Summary view: periods ('copies' is a period)
  # periods -> total used in period 
  attr_accessor :group, :subscriptions, :summary_view, :surveys, :periods, :detailed_view, :params

  def initialize(group, surveys = nil, subscriptions = nil, params = {}) # for a group
    subscriptions ||= group.subscriptions(:include => :copies)
    surveys ||= group.surveys
    @group = group
    @params = params
    @detailed_view = [] #{}
    @summary_view = []
    @subscriptions = subscriptions.sort_by { |s| s.survey_id }
    @surveys = surveys.to_hash_with_key { |s| s.id }
    self.calculate_periods
    self.details
    self
  end
  
  # input: group / all subscriptions for a group

  def periods # needs list of copies for all subscriptions
    
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
      :active => active_count,
      :paid => (subscription.total_used.to_i - active_count.to_i),
      :state => Subscription.states.invert[subscription.state],
      :start => subscription.created_at#,
      # :survey => @surveys[subscription.survey_id]
    }
  end

  def details # details for all subscriptions
    @subscriptions.each { |subscription| detail(subscription) }
    @detailed_view
  end

  # totals for all subscriptions
  def totals(subscriptions)
    @subscriptions.sum { |s| s.total_used }
  end

  def calculate_periods # count totals in periods
    summaries = @group.subscription_summary(@params).sort_by {|s| s.first }
    summaries.each do |summary|
      date, periods = *summary
      used = periods.inject(0) {|n, p| n + p["used"].to_i }
      active = periods.inject(0) {|n, p| n + p["active_used"].to_i }
      total = periods.inject(0) {|n, p| n + p["total_used"].to_i }
      paid = periods.inject(0) {|n, p| n + p["paid"].to_i }
      stopped_on = periods.first["paid_on"] #detect { |p| p["paid_on"] }.inspect
      # puts "periods: #{periods.inspect}\n"
      # puts "total:#{total}\nused:#{used}\active:#{active}\paid:#{paid}"
      # puts "started:#{date}"
      # puts "stopped(paid):#{stopped_on}\n------------"
      @summary_view << {
        :start_on => date, 
        # :active => active_count,
        # :paid => (subscription.total_used.to_i - active_count.to_i),
        :used => used,
        :active => active,
        :paid => paid,
        :total_used => total, #periods["total_used"].to_i, #periods.sum(&:used),
        :created => date, #periods.first.created_on,
        :stopped_on => stopped_on #periods.last.stopped_on#,
        # :paid_on => (could be nil)
      }
    end
    # @periods = summaries
  end
       
end