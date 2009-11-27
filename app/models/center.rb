class Center < Group
  has_many :teams, :dependent => :destroy
  has_many :journals #, :dependent => :destroy  # should never delete journals. TODO: some way to reclaim deleted/dangling journals
  has_many :subscriptions, :include => [:survey], :dependent => :destroy, :uniq => true
  has_many :surveys, :through => :subscriptions, :order => :position, :uniq => true
  has_one  :center_info
  has_many :users,
           :class_name => 'User',
           :conditions => 'users.login_user = 0',
           :dependent => :destroy
  has_many :login_users,
           :class_name => 'User',
           :conditions => 'users.login_user = 1',
           :dependent => :destroy
  has_many :all_users,
           :class_name => 'User',
           :dependent => :destroy

  validates_format_of :code, :with => /[0-9][0-9][0-9][0-9]/ #:is => 4 #, :message => "skal være 4 cifre"
  validates_uniqueness_of :code #, :message => "skal være unik"
  
  named_scope :search_title_or_code, lambda { |phrase| { :conditions => ["groups.title LIKE ? OR groups.code LIKE ?", phrase = "%" + phrase.sub(/\=$/, "") + "%", phrase] } }
  
  # def validate
  #   unless self.code.to_s.size == 4
  #     errors.add("code", "skal være 4 cifre")
  #   end
  # end
  
  # team code must be unique within the same center
  # def validate_on_create
  #   if self.code.to_s.length != 4
  #     errors.add(:code, "skal være fire cifre")
  #   end
  #   if Center.find_by_code(:code)
  #     errors.add(:id, "skal være unik")
  #   end
  # end
  
  def center
    self
  end

  def center_info=(attributes)
    self.center_info && self.build_center_info(attributes) || CenterInfo.new(attributes)
    # if self.center_info
    # self.center_info.build(attributes)
  end
  
  def city; center_info && center_info.city; end
  def street; center_info && center_info.street; end
  def zipcode; center_info && center_info.zipcode; end
  def telephone; center_info && center_info.telephone; end
  def person; center_info && center_info.person; end
  def ean; center_info && center_info.ean; end
    
  # returns subscription for the specified survey
  def get_subscription(survey_id)
    (s = self.subscriptions.by_survey(survey_id)) && s.first
  end
  
  # returns subscribed surveys
  def subscribed_surveys
    subscriptions.active.map { |sub| sub.survey }.sort_by { |s| s.position }
  end
  
  def subscribed_surveys_in_age_group(age)
    subscribed_surveys.select do |survey|
      survey.age_group === age or survey.age_group === (age-1) or survey.age_group === (age+1)
    end
  end
  
  def update_subscriptions(surveys)
    subscriptions = Subscription.for_center(self)
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
      sub.center = self
      self.subscriptions << sub
    end
    
  rescue ActiveRecord::RecordNotFound
    surveys.each do |survey|
      self.subscriptions << Subscription.new(self, survey, 1)
    end
  end
  
  # increment subscription count - move to journal_entry, higher abstraction
  def use_subscribed(survey)
    # find subscription to increment, must be same as is journal_entry
    subscription = self.subscriptions.by_survey(survey) 
    return false unless Subscription
    subscription.copy_used!  #  if sub.nil?  => no abbo
  end

  # shows no. used questionnaires in subscriptions
  def used_subscriptions
    self.subscriptions.inject(0) { |memo,sub| sub.copies_used + memo;  }
  end

  # finds all periods for all subscriptions
  def subscription_summary(options = {})
    periods = Query.new.query_subscription_periods_for_centers(self.id)
    periods.group_by {|c| c["created_on"] }
  end

  def subscription_presenter
    SubscriptionPresenter.new(self)
  end
  
  # set active periods to paid. Create new periods  
  def set_active_subscriptions_paid!
    self.subscriptions.all { |sub| sub.pay! }
  end

  def undo_pay_subscriptions!
    self.subscriptions.each { |sub| sub.undo_pay! }
  end

  # did center ever pay a subscription?
  def paid_subscriptions?
    !self.subscriptions.map { |sub| sub.periods.paid }.flatten.empty?
  end
  
  # return the next team id. Id must be highest id so far plus 1, and if doesn't exist
  def next_team_id
    id = team_ids.max { |p,q| p <=> q }
    id.nil? ? 1 : id + 1
  end
    
  # return the next journal id. Id must be highest id so far plus 1, and if doesn't exist
  def next_journal_id
    id = journal_ids.max { |p,q| p <=> q }
    id.nil? ? 1 : id + 1
  end

  # returns ids of all journals in center
  def journal_ids
    self.journals.collect { |pj| pj.code }
  end
    
  protected
  
  # returns ids of all teams in center
  def team_ids
    self.teams.collect { |t| t.code }
  end

  
  validates_uniqueness_of :title, 
                          :message => 'er navnet på et allerede eksisterende center.'
                          
# TODO, does not work  # validates_length_of     :code, :is => 4,
                          # :message => ': skal være på 4 cifre'

  validates_uniqueness_of :code, 
                          :message => 'er ID for et allerede eksisterende center.'                          
end
