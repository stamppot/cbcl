class Subscription < ActiveRecord::Base
  belongs_to :center
  belongs_to :survey
  has_many :periods #, :dependent => :delete_all

  after_create :new_period!

  named_scope :for_center, lambda { |center| { :conditions => ['center_id = ?', center.is_a?(Center) ? center.id : center] } }
  named_scope :by_survey, lambda { |survey| { :conditions => ['survey_id = ?', survey.is_a?(Survey) ? survey.id : survey] } }
  
  named_scope :active, :conditions => [ 'state = ?', 1 ]
  named_scope :inactive, :conditions => [ 'state = ?', 2 ]
  named_scope :locked, :conditions => [ 'state = ?', 3 ]
  named_scope :deleted, :conditions => [ 'state = ?', 4 ]
  
  validates_presence_of :survey
  validates_presence_of :center
  
  # alias_method :periods, :copies
  
  def new_period!
    self.periods << Period .new({:active => true})
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
      new_copy = Period .create({:active => true})
      self.periods << new_copy
      self.save
      active_period = new_copy
    end
    active_period
  end
  
  def active_periods_used
    find_active_period.used
  end
  
  # subscribed survey has been used
  def copy_used!
    find_active_period.copy_used!
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
    # SELECT subscriptions.center_id, subscriptions.id, SUM(used) FROM cbcl_production.subscriptions, cbcl_production.periods
    #where subscriptions.id = periods.subscription_id
    #group by subscriptions.id
    self.periods.map { |c| c.used }.sum #inject { |sum, n| sum + n }
  end
  
  def inactive_used
    self.total_used - self.find_active_period.used
  end
  
  def subscriptions_count
    result = Query.new.query_subscriptions_count(self)
  end  

  def self.subscriptions_count(center = nil, group_by = 'center_id')
    result = Query.new.query_subscriptions_count(center)
    result = result.group_by { |h| h[group_by].to_i } unless center
    result
  end
  
  def new_period!
    active_period = find_active_period
    active_period.pay!
    # self.periods.create_copy({:active => true})
    self.periods << Period .create({:active => true, :subscription => self})
  end

  def undo_new_period!
    active_period = find_active_period
    if active_period
      used = active_period.used
      if second_last_copy = self.periods.inactive.paid.last
        second_last_copy.used += used
        second_last_copy.undo_pay!
        active_period.destroy
      end
    end
  end
  
  # consolidate active Period  obj and start new
  def pay!
    active_period = find_active_period
    active_period.pay!
    # self.periods.create_copy({:active => true})
    self.periods << Period .create({:active => true, :subscription => self})
    # self.save
  end

  def undo_pay!
    active_period = find_active_period
    if active_period
      used = active_period.used
      if second_last_copy = self.periods.inactive.paid.last
        second_last_copy.used += used
        second_last_copy.undo_pay!
        active_period.destroy
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
  
  private
  
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