require 'access'

class User < ActiveRecord::Base
  include ActiveRbacMixins::UserMixins::Core

  after_save    :expire_cache # delete cached roles, # groups
  after_destroy :expire_cache
  
  belongs_to :center
  
  validates_associated :center # center must be valid
  validates_associated :roles
  validates_presence_of :roles#, :message => "skal angives"
  # user must belong to a group unless he's superadmin or admin
  validates_associated :groups, :if => Proc.new { |user| !user.has_role?(:superadmin, :admin) }
  validates_presence_of :groups, :if => Proc.new { |user| !user.has_role?(:superadmin, :admin) }

  attr_accessor :perms
  
  def access?(permission)
    self.perms && self.perms.include?(permission)
  end  
  
  def has_access?(right)
    role_titles = Access.roles(right) # << "SuperAdmin"  # SuperAdmin has access to everything
    return false if role_titles.nil?

    _all_roles = Rails.cache.fetch("user_roles_#{self.id}") do self.all_roles end
    _all_roles.map.any? do |role| 
      role_titles.include?(role.title.to_sym)
    end
  end
  
  named_scope :in_center, lambda { |center| { :conditions => ['center_id = ?', center.is_a?(Center) ? center.id : center] } }
  named_scope :users, :conditions => ['login_user = ?', false], :order => "created_at"
  named_scope :login_users, :conditions => ['login_user = ?', true]
  named_scope :with_roles, lambda { |role_ids| { :select => "users.*", :joins => "INNER JOIN roles_users ON roles_users.user_id = users.id",
    :conditions => ["roles_users.role_id IN (?)", role_ids] } }

  named_scope :in_journals, lambda { |journal_ids| { :select => "users.*", :joins => "INNER JOIN journal_entries ON journal_entries.user_id = users.id",
    :conditions => ["journal_entries.journal_id IN (?)", journal_ids] } }
  
  def expire_cache
    Rails.cache.delete("user_roles_#{self.id}")
  end
    
  def admin?
    self.has_role?(:admin) or self.has_role?(:superadmin)
  end
  
  #   {"user"=>{"roles"=>["5"], "name"=>"behandler test 22222", "groups"=>["121"], "login"=>"test 22222", "state"=>"2", "email"=>"behandler22222@test.dk"}, "submit"=>{"create"=>"Opret"}, "password_confirmation"=>"[FILTERED]", "action"=>"create", "controller"=>"active_rbac/user", "password"=>"[FILTERED]"}
  def create_user(params)
    # if user name not provided, it's same as login
    params[:name] = params[:login] if params[:name].blank?

    roles  = params.delete(:roles)
    groups = params.delete(:groups)
    # TODO: check parameters for SQL/HTML etc
    pw     = params.delete(:password)
    pwconf = params.delete(:password_confirmation)
    user = User.new(params)
    
    self.update_roles_and_groups(user, roles, groups)
    user.password_hash_type = "md5"
    user.password = pw
    user.password_confirmation = pwconf
    user.last_logged_in_at = 10.years.ago
    
    return user
  end


  def access_to_roles?(roles)
    roles = Role.find(roles || [])
    owner_roles = self.pass_on_roles
    roles.all? { |role| owner_roles.include?(role) }
  end

  def access_to_groups?(groups)
    groups = Group.find(groups || [])
    owner_groups = self.center_and_teams
    groups.all? { |group| owner_groups.include?(group) }
  end

  # TODO: this belongs to refactored version. Copy to other project
  def update_user(user, params) # user is the user who is being updated
    roles  = params.delete(:roles) || []
    groups = params.delete(:groups) || []
    
    if self.access_to_roles?(roles) && self.access_to_groups?(groups)
      self.update_roles_and_groups(user, roles, groups)
    else
      return false
    end

    # only update password when given
    unless params[:password].blank?
      user.password = params.delete(:password)
      user.password_confirmation = params.delete(:password_confirmation)
    end
    user.update_attributes(params)
  end

  # helper method used by methods above
  def update_roles_and_groups(user, roles, groups)
    if self.access_to_roles?(roles) && self.access_to_groups?(groups)
      roles = Role.find(roles || [])
      groups = Group.find(groups || [])

      user.roles += roles
      user.groups += groups

      user.center = groups.first.center unless groups.empty? or user.has_role?(:superadmin)
      user.save
      
      return user
    end
    return false
  end

  
  def access
    return Access.instance
  end
  
  def get_access(right)
    return Access.instance.roles(right.to_sym)
  end
          
  def status
  	rolename = case self.title
    when "parent":    "forælder"
    when "youth":     "barn"
	  when "teacher":   "lærer"
	  when "pedagogue": "pædagog"
	  when "other":     "andet"
	  else self.title
	  end
  end
  
  def member_of?(group)
    group.users.include? self
  end
  
  # is User part of any groups in hierarchy
  def belongs_to?(group)
    group.all_users.include? self
  end

  # not strict, localadm also has access
  def team_member?(team)
    id = (team.instance_of? Team) ? team.id : team
    self.teams.map { |t| t.id }.include? id
  end
 
  def center_member?(center)
    id = (center.instance_of? Center) ? center.id : center
    if(self.has_access? :center_show_all)
      self.centers.map(&:id).include? id
    elsif self.center
      self.center.id == id
    else
      false
    end
  end
  
  # TODO rewrite if user.center works
  def center_and_teams
    if(self.has_access?(:admin))
      Group.center_and_teams #find(:all, :conditions => ['type != ?', "Journal"])
    elsif self.has_access? :team_show_admin # self.center
      if self.centers.size > 1 # some people have more centers
        self.centers + self.centers.map { |c| c.teams }.flatten
      else
        [self.center] + self.center.teams
      end
    elsif self.has_access? :team_show
      self.groups
    else
      groups = self.centers #current_user.center #self.center
      groups.each do |center| 
        center.children.each { |team| groups << team if team.instance_of? Team }
      end
    end
  end
    
  def surveys
    surveys = []
    if self.has_access?(:survey_show_all)
      surveys = Survey.find(:all, :order => :position)
    elsif self.has_access?(:survey_show_subscribed)
      surveys = self.center.surveys
    elsif self.has_access?(:survey_show_login)
      journal_entry = JournalEntry.find_by_user_id(self.id)
      surveys = [journal_entry.survey]
    else
      surveys = []
    end
    surveys
  end

  # returns only active surveys which user's centers are subscribed to
  def subscribed_surveys
    if self.has_access?(:survey_show_all)
      s = Survey.all(:order => :position)
      # s.delete_if {|s| s.title =~ /Test/}
      # s
    elsif self.has_access?(:survey_show_subscribed)
      self.center.subscribed_surveys
    elsif self.has_access?(:survey_show_login)
      surveys = []
      journal_entry = JournalEntry.find_by_user_id(self.id)
      surveys << journal_entry.survey if journal_entry.survey
    else
      surveys = []
    end
  end
  
  def centers
    options = {:include => :users}
    centers =
    if self.has_access?(:center_show_all)
      Center.find(:all, options) #.delete_if { |group| group.instance_of? Journal or group.instance_of? Team }    # filtrer teams fra
    elsif self.has_access?(:center_show_admin)
      self.groups.delete_if { |group| group.instance_of? Journal or group.instance_of? Team }
    elsif self.has_access?(:center_show_member)
      [self.center] # self.all_groups.delete_if { |group| group.instance_of? Journal or group.instance_of? Team }
    elsif self.has_access?(:center_show_all)
      self.all_groups.delete_if { |group| group.instance_of? Journal or group.instance_of? Team }
    else
      []
    end
    centers
  end
  
  # must reload from DB
  def teams(reload = false)
    options = {:include => [:center, :users]}
    teams =
    if self.has_access?(:team_show_all)
      Team.find(:all, options)
    elsif self.has_access?(:team_show_admin)
      Team.in_center(self.center_id) # Team.find(:all, :conditions => ['parent_id = ?', self.center_id])
    elsif self.has_access?(:team_show_member)
      Team.direct_groups(self)
    else
      []
    end
  end
  
  # journals a user has access to
  # behandler should only have access to journals in his teams (groups), thus excluding journals from other teams, but not the center
  def journals(options = {})
    options[:page] ||= 1
    options[:per_page] ||= REGISTRY[:journals_per_page]

    journals =
    if self.has_access?(:journal_show_all)
      if options[:page] < 4 # only cache first pages, since they're used more often
        Rails.cache.fetch("journals_all_paged_#{options[:page]}_#{options[:per_page]}") do
          Journal.and_person_info.paginate(:all, options)
        end
      else
        Journal.and_person_info.paginate(:all, options)
      end
    elsif self.has_access?(:journal_show_centeradm)
      Rails.cache.fetch("journals_groups_#{self.center_id}_paged_#{options[:page]}_#{options[:per_page]}", :expires_in => 10.minutes) do
        Journal.and_person_info.in_center(self.center).paginate(:all, options)
      end
    elsif self.has_access?(:journal_show_member)
      group_ids = self.group_ids(options[:reload]) # get teams and center ids for this user
      if options[:page] < 4 # only cache first 5 pages
        journals = Rails.cache.fetch("journals_groups_#{group_ids.join("_")}_paged_#{options[:page]}_#{options[:per_page]}") do
          Journal.and_person_info.all_parents(group_ids).paginate(:all, options)
        end
      else 
        Journal.and_person_info.all_parents(group_ids).paginate(:all, options)
      end
    elsif self.has_access?(:login_user)
      entry = JournalEntry.find_by_user_id(self.id)
      [entry.journal]
    elsif self.has_access?(:journal_show_none)
      journals = []
      journals = WillPaginate::Collection.create(options[:page], options[:per_page]) do |pager|
        pager.replace(journals) # inject the result array into the paginated collection:
      end
    else  # for login-user
      []  # or should it be the journal the login_user is connected to?
    end
    return journals
  end

  # returns journal ids that this user can access. Used by check_access. SQL optimized
  def journal_ids
    j_ids = 
    if self.has_access?(:journal_show_all)
      journal_ids = Rails.cache.fetch("journal_ids_user_#{self.id}") { Journal.find(:all, :select => "id") }
    elsif self.has_access?(:journal_show_centeradm)
      journal_ids = Rails.cache.fetch("journal_ids_user_#{self.id}") { Journal.in_center(self.center).find(:all, :select => "id") }
    elsif self.has_access?(:journal_show_member)
      group_ids = self.group_ids(:reload => true) # get teams and centers for this users
      journal_ids = Rails.cache.fetch("journal_ids_user_#{self.id}") { Journal.all_parents(group_ids).find(:all, :select => "id") }
    elsif self.has_access?(:journal_show_none)
      []
    else  # for login-user
      []  # or should it be the journal the login_user is connected to?
    end
    return j_ids.map {|j| j.id}
  end

  # TODO: optimize query!!
  def journal_entry_ids
    options = { :select => "id", :include => [:journal_entries] }
    if self.has_access?(:journal_show_all)
      journal_entry_ids = Rails.cache.fetch("journal_entry_ids_user_#{self.id}") do
        Journal.and_entries.find(:all, options).map {|g| g.journal_entries}.flatten!.map {|e| e.id}
      end
    elsif self.has_access?(:journal_show_centeradm)
      journal_entry_ids = Rails.cache.fetch("journal_entry_ids_user_#{self.id}") do
        Journal.and_entries.in_center(self.center).find(:all, options).map {|g| g.journal_entries}.flatten!.map {|e| e.id}
      end
    elsif self.has_access?(:journal_show_member)
      journal_entry_ids = Rails.cache.fetch("journal_entry_ids_user_#{self.id}") do
        Journal.and_entries.all_parents(self.group_ids).find(:all, options).map {|g| g.journal_entries}.flatten!.map {|e| e.id}
      end
    elsif self.has_access?(:journal_show_none)
      []
    else  # for login-user
      []  # or should it be the journal the login_user is connected to?
    end
    # return journals.map {|g| g.journal_entries}.flatten!.map {|e| e.id}
  end

  # finished survey answers, based on accessible journals
  def survey_answers(options = {})  # params are not safe, should only allow page/per_page
    page = options[:page] ||= 1
    per_page = options[:per_page] ||= 100000
    start_date = options.delete(:start_date) || SurveyAnswer.first.created_at
    stop_date  = options.delete(:stop_date) || SurveyAnswer.last.created_at
    start_age  = options.delete(:age_start) || 0
    stop_age   = options.delete(:age_stop) || 21

    surveys    = options.delete(:surveys)
    je_ids = Rails.cache.fetch("journal_entry_ids_user_#{self.id}") do
      self.journal_entry_ids
    end
    
    # options[:limit] ||= 33
    # options[:offset] ||= 0
    # options[:conditions] ||= []
    # puts "options conditions: #{options.inspect}"
    
    if self.has_access?(:group_all)
      SurveyAnswer.for_surveys(surveys).finished.between(start_date, stop_date).aged_between(start_age, stop_age).paginate(:conditions => ['journal_entry_id IN (?)', je_ids], :page => page, :per_page => per_page )
      # SurveyAnswer.for_surveys(surveys).finished.between(start_date, stop_date).aged_between(start_age, stop_age).
      # paginate(options.merge(:conditions => ['journal_entry_id IN (?)', je_ids], :page => page, :per_page => per_page )) #, :include => [{:journal_entry => :journal}, :survey])
    else #if self.has_role?(:teamadministrator) or self.has_role(:behandler)
      journal_ids = Rails.cache.fetch("journal_ids_user_#{self.id}") { self.journal_ids }
      sa_ids = JournalEntry.answered.for_surveys(surveys).all(:conditions => ['id in (?)', journal_ids]).map {|je| je.survey_answer_id }
      SurveyAnswer.for_surveys(surveys).finished.between(start_date, stop_date).aged_between(start_age, stop_age).paginate(options.merge(:conditions => ['id IN (?)', sa_ids]))
    end
  end
  
  def count_survey_answers(options = {})  # params are not safe, should only allow page/per_page
    # options[:page] ||= 1
    # options[:per_page] ||= 100000
    start_date = options.delete(:start_date) || SurveyAnswer.first.created_at
    stop_date  = options.delete(:stop_date) || SurveyAnswer.last.created_at
    start_age  = options.delete(:age_start) || 0
    stop_age   = options.delete(:age_stop) || 21

    surveys    = options.delete(:surveys)
    je_ids = Rails.cache.fetch("journal_entry_ids_user_#{self.id}") do
      self.journal_entry_ids
    end
    puts "options : #{options.inspect}"
        
    if self.has_access?(:group_all)
      SurveyAnswer.for_surveys(surveys).finished.between(start_date, stop_date).aged_between(start_age, stop_age).count(:conditions => ['journal_entry_id IN (?)', je_ids])

      # SurveyAnswer.for_surveys(surveys).finished.between(start_date, stop_date).aged_between(start_age, stop_age).count(options.merge(:conditions => ['journal_entry_id IN (?)', je_ids]))
    else
      journal_ids = Rails.cache.fetch("journal_ids_user_#{self.id}") { self.journal_ids }
      sa_ids = JournalEntry.answered.for_surveys(surveys).all(:conditions => ['id in (?)', journal_ids]).map {|je| je.survey_answer_id }
      SurveyAnswer.for_surveys(surveys).finished.between(start_date, stop_date).aged_between(start_age, stop_age).count(options.merge(:conditions => ['id IN (?)', sa_ids]))
    end
  end
  
  
  def login_users(options = {})
    options[:page] ||= 1
    options[:per_page] ||= 100000 
    journal_ids = Rails.cache.fetch("journal_ids_user_#{self.id}", :expires_in => 10.minutes) { self.journal_ids }
    users = User.login_users.in_journals(journal_ids).paginate(:all, options)
  end
  
  # returns users that a specific user role is allowed to see
  def get_users(options = {})
    options[:include] = [:roles, :groups, :center]
    options[:page]  ||= 1
    users = if self.has_access?(:user_show_all)  # gets all users which are not login-users
      User.users.with_roles(Role.get_ids(Access.roles(:all_real_users))).paginate(options).uniq
    elsif self.has_access?(:user_show_admins)
      User.users.with_roles(Role.get_ids(Access.roles(:user_show_admins))).paginate(options)
    elsif self.has_access?(:user_show)
      User.users.in_center(self.center).paginate(options)
    else
      WillPaginate::Collection.new(options[:page], options[:per_page])
    end
    return users
  end
    
  # roles a user can pass on
  def pass_on_roles
    r = self.all_roles
    # r = self.all_roles
    if self.has_access?(:superadmin)
      r = Role.get(Access.roles(:all_users))
    elsif self.has_access?(:admin)
      r = Role.get(Access.roles(:admin_roles))
    elsif self.has_access?(:centeradm)
      r = Role.get(Access.roles(:center_users))
    end
    return (r.is_a?(Array) ? r : [r])
  end
  
  def status
    case self.state
    when 1: 'ubekræftet'
    when 2: 'bekræftet'
    when 3: 'låst'
    when 4: 'slettet'
    when 5: 'retrieved_password'
      # The user has just retrieved his password and he must now
      # it. The user cannot anything in this state but change his
      # password after having logged in and retrieve another one.
    when 6: 'retrieved_password'
    when 'ubekræftet': 1
    when 'bekræftet': 2
    when 'låst': 3
    when 'slettet': 4
    when 'new_password': 5
    when 'retrieved_password': 6
    end
  end

  def User.stateToStatus(hash)
    ret = Hash.new
    hash.each do |key,val|
      case key
      when 'unconfirmed': ret['ubekræftet'] = val
      when 'confirmed': ret['bekræftet'] = val
      when 'locked': ret['låst'] = val
      when 'deleted': ret['slettet'] = val
      end
    end
    return ret
  end


  protected
  
  def per_page
    REGISTRY[:journals_per_page]
  end
  
    # # This method allows to execute a block while deactivating timestamp
    # # updating.
    # def self.execute_without_timestamps
    #   old_state = ActiveRecord::Base.record_timestamps
    #   ActiveRecord::Base.record_timestamps = false
    # 
    #   yield
    # 
    #   ActiveRecord::Base.record_timestamps = old_state
    # end

    validates_presence_of   :login, :email, :password, :password_hash_type, :state,
                            :message => 'skal angives'

    validates_uniqueness_of :login, 
                            :message => 'findes allerede. Login skal være unikt.'
    validates_format_of     :login, 
                            :with => %r{^[\(w|Æ|Ø|Å|æ|ø|å|\w) \$\^\-\.#\*\+&'"]*$},    #{^[\w \$\^\-\.#\*\+&'"]*$}, 
                            :message => 'må ikke indeholde ugyldige tegn.'
    validates_length_of     :login, 
                            :in => 4..100, :allow_nil => true,
                            :too_long => 'skal have mindre end 100 bogstaver.', 
                            :too_short => 'skal have mere end 4 bogstaver.'

    # We want a valid email address. Note that the checking done here is very
    # rough. Email adresses are hard to validate now domain names may include
    # language specific characters and user names can be about anything anyway.
    # However, this is not *so* bad since users have to answer on their email
    # to confirm their registration.
    validates_format_of :email, 
                        :with => %r{^([\w\-\.\#\$%&!?*\'=(){}|~_]+)@([0-9a-zA-Z\-\.\#\$%&!?*\'=(){}|~]+)+$},
                        :message => 'skal være en gyldig e-mail adresse.'

    # Overriding this method to do some more validation: Password equals 
    # password_confirmation, state an password hash type being in the range
    # of allowed values.
    def validate
      # validate state and password has type to be in the valid range of values
      errors.add(:password_hash_type, "must be in the list of hash types.") unless User.password_hash_types.include? password_hash_type
      # check that the state transition is valid
      errors.add(:state, "must be in the list of states.") unless state_transition_allowed?(@old_state, state)

      # validate the password
      if @new_password and not password.nil?
        errors.add(:password, 'må ikke være samme som brugernavn.') if password == :login
        errors.add(:password, 'må ikke være \'password\'.') if password == "password"
        errors.add(:password, 'skal have mellem 6 og 64 bogstaver eller tal.') unless password.length >= 6 and password.length <= 64
        errors.add(:password, 'skal passe med bekræftelse.') unless password_confirmation == password
        errors.add(:password, 'må ikke indeholde ugyldige bogstaver.') unless password =~ %r{^[\w\.\- !?(){}|~*_]+$}
      end

      # check that the password hash type has not been set if no new password
      # has been provided
      # if @new_hash_type and not (@new_password or password.nil?)
      #   errors.add(:password_hash_type, 'kan ikke ændres hvis password ikke er givet.')
      # end
    end
    
end