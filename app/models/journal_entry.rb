class JournalEntry < ActiveRecord::Base
  belongs_to :journal #, :touch => true
  belongs_to :survey
  belongs_to :survey_answer, :dependent => :destroy, :touch => true
  belongs_to :login_user, :class_name => "LoginUser", :foreign_key => "user_id", :dependent => :destroy  # TODO: rename to login_user, add type constraint

  validates_associated :login_user
  # validates_uniqueness_of :follow_up, :scope => :journal_id #, :message => "bruges allerede. Vælg andet ID."
  # validate :follow_up_validation

  named_scope :and_login_user, :include => :login_user
  named_scope :and_survey_answer, :include => [:survey, :survey_answer]
	named_scope :for_center, lambda { |center_id| { :joins => :journal, :conditions => ["center_id = ?", center_id] } }
  named_scope :with_surveys, lambda { |survey_ids| { :joins => :survey_answer,
   :conditions => ["survey_answers.survey_id IN (?)", survey_ids] } }
  named_scope :for_surveys, lambda { |survey_ids| { :conditions => ["survey_id IN (?)", survey_ids] } }
  named_scope :unanswered, :conditions => ['state < ?', 5]
  named_scope :answered, :conditions => ['state = ?', 5]
  named_scope :answered_by_login_user, :conditions => ['state = ?', 6]
  named_scope :for_states, lambda { |states| { :conditions => ["state IN (?)", states]}}
  named_scope :with_cond, lambda { |cond| cond }
  named_scope :between, lambda { |start, stop| { :conditions => { :created_at  => start..stop } } }

  def self.follow_ups
    [["Diagnosticering", 0], ["1. opfølgning", 1], ["2. opfølgning", 2], ["3. opfølgning", 3]]
  end

  def get_follow_up
    self.follow_up ||= 0
    JournalEntry.follow_ups[follow_up].first
  end

  # def follow_up_validation
  #   is_invalid = journal.has_follow_up?(self)
  #   errors.add(:follow_up, "Journalen har allerede et skema med denne opfølgning: #{get_follow_up}") if is_invalid
  # end

  def get_title
    t = survey.title.gsub("skema", "")
    t += " #{self.get_follow_up}"
  end

  def expire_cache(user)
    # Rails.cache.delete("journal_entry_ids_user_#{user.id}")
  end
  
  def make_survey_answer
    self.survey_answer ||= self.build_survey_answer(:survey => self.survey,
                             :sex => self.journal.sex,
                             :age => self.journal.age, # age at moment of answering
                             :nationality => self.journal.nationality,
                             :journal_entry_id => self.id,
                             :journal_id => self.journal_id,
                             :surveytype => self.survey.surveytype,
                             :center_id => self.journal.center_id)   
    self.survey_answer.journal_entry = self
    self.survey_answer
  end

  # deletes login user
  def remove_login!
    return self.login_user.destroy if self.login_user
    return false
  end

  def is_parent_survey?
    [1,2].include?(survey_id)
  end
  
  def is_teacher_survey?
    [3,4].include? survey_id
  end

  def destroy_and_remove_answers!
    self.remove_login!
    self.survey_answer.destroy if self.survey_answer
  end
  
  def valid_for_csv?
    if survey_answer_id && survey_id && journal_id && answered?
      return self
    else
      return nil
    end
  end
  
  # increment subscription count
  # 19-9 find better name
  def increment_subscription_count(survey_answer)
    self.survey_answer = survey_answer
    self.answered_at = Time.now
    center = self.journal.center
    
    # find subscription to increment, must be same as is journal_entry
    subscription = center.get_subscription(survey_answer.survey_id)  #s.detect { |sub| sub.survey.id == survey.id }
    return false if subscription.nil?                               # no abbo exists
    subscription.copy_used!
    self.save    # saves objects
  end
    
  def status
    JournalEntry.states.invert[self.state]
  end

  def answer_status
    return "Besvaret" if [5,6].include? self.state
    return "Ubesvaret" if self.state == 2
    return status
  end
  
	def answered_by
		if !survey_answer.blank? && survey_answer.answered_by.to_i > 0
			role = Role.find(survey_answer.answered_by == 88 && 15 || survey_answer.answered_by)
			return role.title
		end
  end

  def answered?
    (self.state == JournalEntry.states['Elektronisk'] || self.state == JournalEntry.states['Papir']) &&
    (self.state != JournalEntry.states['Ubesvaret'] || self.state != JournalEntry.states['Sendt ud'] || self.state != JournalEntry.states['Venter'])
  end                                   
                                        
  def answered!                           
    self.state = JournalEntry.states['Elektronisk']  
    self.save!
  end

  def answered_paper!
    self.state = JournalEntry.states['Papir']  
    self.save!
  end

	def answered_paper?
    self.state == JournalEntry.states['Papir']  
  end

  def not_answered?
    self.state != JournalEntry.states['Elektronisk'] || self.state != JournalEntry.states['Papir'] # Ubesvaret
  end
  
  def not_answered!
    self.state = JournalEntry.states['Ubesvaret']   # Ubesvaret
    self.save!
  end
  
  def draft?
    self.state == JournalEntry.states['Kladde']  # Svarkladde er påbegyndt
  end
  
  def draft!
    self.state = JournalEntry.states['Kladde']   # Svarkladde
    self.save!
  end

  def awaiting_answer?
    self.state == JournalEntry.states['Venter']  # Venter
  end

  def awaiting_answer
    self.state = JournalEntry.states['Venter']   # Venter
  end
  
  def awaiting_answer!
    self.state = JournalEntry.states['Venter'] # 'Venter'
    self.save
  end
  
  def print_login?
    self.state == print_login
  end

  def print_login
    self.state = JournalEntry.states['Sendt ud'] # print eller skal sendes
  end
  
  def print_login!
    self.print_login
    self.save
  rescue => e
    puts "JournalEntry.print_login!: #{e.inspect}"
  end
  
  # reset state unless it has been answered
  def remove_login_user!
    self.user = nil    # set to unanswered unless answered
    self.state = JournalEntry.states[JournalEntry.states.invert[1]] unless self.state == JournalEntry.states[JournalEntry.states.invert[4]]
    self.save
  end
  
  def JournalEntry.for_parent_with_state(parent, states)
    JournalEntry.for_states(states).with_cond(:conditions => ['parent_id = ?', parent.is_a?(Group) && parent.id || parent], :joins => :journal)
  end
  
  def JournalEntry.states  # ikke besvaret, besvaret, venter på svar (login-user)
    { #'Fejl'       => 0,
      # 'Ubesvaret'  => 1,
      'Sendt ud'   => 2,
      # 'Venter'     => 3,   # venter paa at login-bruger svarer paa skemaet
      'Kladde'     => 4,
      'Papir'   	 => 5,    # besvaret af behandler
			'Elektronisk' => 6,		# besvaret af login-bruger
      'Rykket'      => 7,
      'Afsluttet'   => 8
       }
  end
  
  def make_login_user(password = nil)
    login = journal.parent.login_prefix
    group_name = journal.parent.group_name_abbr
    params = LoginUser.create_params(login, group_name)
    pw = password && {:password => password, :password_confirmation => password} || PasswordService.generate_password
    login_user = LoginUser.new(params)
    # set protected fields explicitly
    login_user.center_id = journal.center_id
    login_user.roles << Role.get(:login_bruger)
    login_user.groups << journal
    login_user.password, login_user.password_confirmation = pw.values
    login_user.password_hash_type = "md5"
    login_user.last_logged_in_at = 10.years.ago
    self.password = pw[:password]
    self.login_user = login_user
    unless login_user.valid?
      raise InvalidUserException "invalid LoginUser: #{login_user.inspect}"
    end
    return login_user
  end
end
