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
  has_many :survey_answers           
	has_many :center_settings
	
  validates_format_of :code, :with => /[0-9][0-9][0-9][0-9]/ #:is => 4 #, :message => "skal være 4 cifre"
  validates_uniqueness_of :code #, :message => "skal være unik"
  
  named_scope :search_title_or_code, lambda { |phrase| { :conditions => ["groups.title LIKE ? OR groups.code LIKE ?", phrase = "%" + phrase.sub(/\=$/, "") + "%", phrase] } }
  
  attr_accessor :subscription_service, :subscription_presenter
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
      # be a bit flexible in which surveys can be used for which age groups, fx 11-16 can be used up to 18 years
      age_flex = (survey.age =~ /16|17|18/) && 4 || 1
      survey.age_group === age or survey.age_group === (age+2) or survey.age_group === (age-age_flex)
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

  def subscription_presenter(surveys = nil)
    @subscription_presenter ||= SubscriptionPresenter.new(self, surveys)
  end

  def subscription_service
    @subscription_service ||= SubscriptionService.new(self)
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

  # returns id codes of all journals in center
  def journal_codes
    self.journals.collect { |j| j.code }
  end

  def login_name_params #(options = {})
    center_name = title.split.map {|w| w.first }.join.downcase
    login = 
    if luser = self.login_users.last
      luser.login =~ /(\d+)/
      "#{center_name}-login" + $1.succ
    else
      "#{center_name}-login1"
    end

    return { :login => login,
      :name => login,
      :email => "#{login}@#{center_name}.dk",
      :state => 2,
      :login_user => true
    }
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
