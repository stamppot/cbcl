class Subscription < ActiveRecord::Base
  belongs_to :center
  belongs_to :survey
  has_many :periods #, :dependent => :delete_all

  before_validation :set_totals
  after_create :new_period!

  named_scope :for_center, lambda { |center| { :conditions => ['center_id = ?', center.is_a?(Center) ? center.id : center] } }
  named_scope :by_survey, lambda { |survey| { :conditions => ['survey_id = ?', survey.is_a?(Survey) ? survey.id : survey] } }
  
  named_scope :active, :conditions => [ 'state = ?', 1 ]
  named_scope :inactive, :conditions => [ 'state = ?', 2 ]
  named_scope :locked, :conditions => [ 'state = ?', 3 ]
  named_scope :deleted, :conditions => [ 'state = ?', 4 ]
  
  validates_presence_of :survey
  validates_presence_of :center

  validates_presence_of :total_paid
  validates_presence_of :total_used
  validates_presence_of :active_used
  
  def set_totals
    self.total_paid ||= 0
    self.total_used ||= 0
    self.active_used ||= 0
  end
  
  def new_period!
    self.periods.build(:active => true, :used => 0)
  end
  
  def Subscription.states
    Subscription.default_states
  end
  
  def states
    Subscription.default_states
  end
  
  def active?
    Subscription.default_states['Aktiv'] == self.state
  end
  
  def inactive?
    !(Subscription.default_states['Aktiv'] == self.state)
  end
  
  def activate!
    self.new_period! unless self.periods.active.empty?
    self.state = self.states['Aktiv']
    self.save
  end
  
  def deactivate!
    self.state = self.states['Inaktiv']
    self.save
  end

  def find_active_period
    active_period = self.periods.active.first
    if active_period.nil?
      new_copy = self.periods.create({:active => true, :used => 0})
      active_period = self.periods.last
    end
    active_period
  end
  
  def unpaid_used
    find_active_period.used
  end
  
  def paid_used
    total_used_subs = total_used || 0
    result = total_used_subs - find_active_period.used
    result < 0 && 0 || result
  end
  
  # subscribed survey has been used
  def copy_used!
    find_active_period.copy_used!
    self.total_used ||= 0
    self.active_used ||= 0
    self.total_used += 1   # total count
    self.active_used += 1
    self.save
  end

  # rolls back last paid copy, sums any use counts
  def set_last_as_unpaid
    active_period = self.find_active_period
    old_period = self.periods[-2]
    old_period.used += active_period.used
    self.total_used += self.active_used
    active_period.destroy && old_period.save && self.save
  end
  
  def periods_used
    self.periods.map { |c| c.used }.sum
  end
  
  # def inactive_used
  #   used_in_total = self.total_used || 0
  #   used_in_total - self.find_active_period.used
  # end
  
  def subscriptions_count
    result = Query.new.query_subscriptions_count(self)
  end  

  def self.subscriptions_count(center = nil, group_by = 'center_id')
    result = cache_fetch("subscriptions_count_#{center.id}", :expires_in => 10.minutes) do
      result = Query.new.query_subscriptions_count(center)
      result = result.group_by { |h| h[group_by].to_i } unless center
    end
    result
  end
  
  def new_period!
    active_period = find_active_period
    active_period.pay!
    self.periods.create(:active => true, :subscription => self, :used => 0)
  end

  # def undo_new_period!
  #   active_period = find_active_period
  #   if active_period
  #     used = active_period.used
  #     if second_last_copy = self.periods.inactive.paid.last
  #       second_last_copy.used += used
  #       second_last_copy.undo_pay!
  #       active_period.destroy
  #     end
  #   end
  # end

  # use when merging periods with no used surveys
  def merge_periods! #(date1, date2)
    active_periods = self.periods.active
    return if active_periods.size == 1 # nothing to do

    first_period = active_periods.shift
    # puts "first period: #{first_period.inspect}"
    # copy subsequent periods to first active
    active_periods.each_with_index do |period, i|
      # puts "#{i} period: #{period.inspect}"
       first_period.used += period.used
     end
    active_periods.each { |p| p.destroy } if first_period.save
    # puts "Done first period: #{first_period.inspect}"
  end

  # pay period
  # def pay_period!(start_date, end_date = Time.now.to_date)
  #   p = self.periods.detect {|p| p.created_on == start_date}
  #   puts "PAYING PERIOD 1: #{p.inspect}"
  #   p.pay!
  #   puts "PAYING PERIOD 2: #{p.inspect}"
  #   self.most_recent_payment = DateTime.now.to_date.to_s(:db)
  #   # begin new period if no active
  #    begin_new_period! unless find_active_period
  # end
  
  # pay active period
  def pay!
    active_period = find_active_period
    self.most_recent_payment = Date.today.to_s(:db)
    active_period.pay!
		update_used_and_total_paid
		self.save
	  begin_new_period!
  end

	def update_used_and_total_paid
		self.total_paid ||= 0
		self.active_used ||= 0
		self.total_paid += self.active_used
		self.active_used = 0
		self.total_paid
		self.most_recent_payment = Date.today
		# puts "update_used_and_total_paid: total_paid #{total_paid}  active_used: #{active_used}"
	end
	
	# TODO: fix
  def undo_pay!
    active_period = self.periods.active.last # find_active_period
    if active_period
      used = active_period.used
      if last_paid_period = self.periods.paid.last
        last_paid_period.used += used
        last_paid_period.undo_pay!
        self.most_recent_payment = last_paid_period.paid_on
        active_period.destroy
				active_period = nil
      end
    end
  end
  
  def summary(options = {})
    results = case options[:show]
    when "active": periods.active
    when "paid": periods.paid
    else 
      periods
    end
    results.group_by { |c| c.created_on }
  end
   
  def begin_new_period!
		p = self.periods.last
		p.active = false
    self.periods.create(:active => true, :subscription => self, :used => 0) if p.save
  end

    # This method returns a hash which contains a mapping of user states 
    # valid by default and their description.
    def Subscription.default_states
      @default_states ||= {
        'Aktiv' => 1,
        'Inaktiv' => 2,
        'Låst' => 3,
        'Slettet' => 4
      }
    end
end