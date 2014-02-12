# encoding: utf-8
# require 'facets/dictionary'
#require 'rake'
# require 'hashery'
class Journal < ActiveRecord::Base # Group
  belongs_to :center
  belongs_to :group
  # has_one :person_info #, :dependent => :destroy
  # has_many :journal_entries, :order => 'created_at', :dependent => :destroy
  has_many :journal_entries, :order => 'created_at', :dependent => :destroy
  has_many :login_users, :through => :journal_entries, :source => :journal_entries
  has_many :surveys, :through => :journal_entries
  has_many :survey_answers
  has_many :csv_answers
  has_many :score_rapports, :through => :survey_answers
  has_many :journal_click_counters # has one per user  
  
  has_many :answered_entries_by_personnel,
           :class_name => 'JournalEntry',
           :include => [:survey],
           :conditions => 'journal_entries.state = 5',  # answered
           :order => 'journal_entries.answered_at'
  has_many :answered_entries_by_login_user,
           :class_name => 'JournalEntry',
           :conditions => 'journal_entries.state = 6',  # answered
           :order => 'journal_entries.answered_at'
	has_many :answered_entries,
	         :class_name => 'JournalEntry',
	         :conditions => 'journal_entries.state >= 5',  # answered
	         :order => 'journal_entries.answered_at'
  has_many :not_answered_entries,
           :class_name => 'JournalEntry',
           :conditions => 'journal_entries.state < 5',  # not answered
           :order => 'journal_entries.answered_at'
  default_scope :order => 'created_at DESC'               
  
  # delegate :name, :to        => :person_info
  # delegate :sex, :to         => :person_info
  # delegate :birthdate, :to   => :person_info, :allow_nil => true
  # delegate :nationality, :to => :person_info
  # delegate :age, :to         => :person_info
  # delegate :sex_text, :to    => :person_info
 
  before_save :set_cpr_nr
 
  after_save    :expire_cache
	after_create  :index_search, :expire_cache
  after_destroy :expire_cache
  # after_destroy :destroy_journal_entries
  # after_destroy :destroy_person_info
  
  # ID is mandatory
  validates_presence_of :code #, :message => "ID skal gives"
  validates_format_of :code, :with => /\d+/
  validates_presence_of :name#, :message => "Navn skal angives"
  validates_presence_of :sex #, :message => "Køn skal angives"
  validates_presence_of :nationality #, :message => "Nationalitet skal angives"
  validates_associated :group #, :message => "Et Center eller team skal angives"
  validates_presence_of :group
  validates_associated :center
  validates_presence_of :center
  # validates_presence_of :person_info
  # validates_associated :person_info
  # journal code must be unique within the same center
  validates_uniqueness_of :code, :scope => :center_id #, :message => "bruges allerede. Vælg andet ID."
  validates_presence_of :sex, :message => "Køn skal angives"
  validates_presence_of :nationality, :message => "Nationalitet skal angives"
  validates_format_of :parent_email, :with => /^(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})$/i  
  
 

  named_scope :and_entries, :include => :journal_entries
  # named_scope :and_login_users, :include => { :journal_entries => :login_user }
  # named_scope :and_person_info, :include => :person_info
  named_scope :for_parent, lambda { |group| { :conditions => ['group_id = ?', group.is_a?(Group) ? group.id : group], :order => 'created_at desc' } }
  named_scope :for_center, lambda { |group| { :conditions => ['center_id = ?', group.is_a?(Center) ? group.id : group], :order => 'created_at desc' } }
  named_scope :by_code, :order => 'code ASC'
  named_scope :for_groups, lambda { |group_ids| { :conditions => ['group_id IN (?)', group_ids] } }
  named_scope :for, lambda { |journal_id| { :conditions => ['id = ?', journal_id] } }
  named_scope :all_parents, lambda { |group_ids| { :conditions => ['group_id IN (?)', group_ids]}}
  named_scope :in_center, lambda { |center| { :conditions => ['center_id = ?', center.is_a?(Center) ? center.id : center] } }
  
  define_index do
     # fields
     indexes :title, :sortable => true
     indexes :code, :sortable => true
     # indexes person_info.cpr, :as => :person_info_cpr
     # indexes person_info.alt_id, :as => :person_info_alt_id
		 indexes :cpr
     indexes :alt_id
     # indexes center_id
     # attributes
     # has group_id, center_id, created_at, updated_at
     has center_id, created_at, updated_at

     set_property :delta => true
   end

  # def validate
  #   unless self.code.to_s.size == Journal.find_by_code_and_center_id(self.code, self.center_id)
  #     errors.add("code", "skal være 4 cifre")
  #   end
  # end 

  def Journal.sexes
    {
      'dreng' => 1,
      'pige' => 2
    }
  end

  def sex_text
    Journal.sexes.invert[self.sex]
  end

  def self.nationalities
    Nationality.all
  end
  
  def age
    ( (Date.today - self.birthdate).to_i / 365.25).floor
  end

  def self.search_journals(user, phrase)
    journals =
    if phrase.empty?
      []
    elsif user.has_role?(:superadmin)
      Journal.search(phrase, :order => "created_at DESC", :per_page => 40)
    elsif user.has_role?(:centeradmin)
      user.centers.map {|c| c.id}.inject([]) do |result, id|
        result + Journal.search(phrase, :with => { :center_id => id }, :order => "created_at DESC", :include => :person_info, :per_page => 40)
      end
    else
      user.group_ids.inject([]) do |result, id|
        result += Journal.search(phrase, :with => {:parent_id => id }, :order => "created_at DESC", :include => :person_info, :per_page => 40)
      end
    end
  end

  def self.run_rake(task_name)
    #load File.join(RAILS_ROOT, 'lib', 'tasks', 'thinking_sphinx_tasks.rake')
    #Rake::Task[task_name].invoke
  end

  def set_cpr_nr
    dato = self.birthdate.to_s.split("-")
    dato[0] = dato[0][2..3]
    self.cpr = dato.reverse.join
  end

  def update_birthdate!(params)
    new_birthdate = Date.new params["birthdate(1i)"].to_i, params["birthdate(2i)"].to_i, params["birthdate(3i)"]
    return false if new_birthdate == self.birthdate
    birthdate = new_birthdate
    save
  end

  def get_project_code
    projects.any? && projects.first.code || ""
  end
  
  def get_name
    title
  end

  def has_follow_up?(entry)
    journal_entries.any? {|e| e.id != entry.id && e.survey_id == entry.survey_id && e.follow_up == entry.follow_up}
  end

  def index_search
		#Journal.run_rake("rake thinking_sphinx:reindex")
	end

  def follow_up_count
    journal_entries.map {|e| e.survey_id}.group_by {|c| c}.map {|c| c.second.size}.max
  end

  def expire
    Rails.cache.delete("j_#{self.id}")
		# Rails.cache.delete("journal_ids_user_#{self.id}")
		# Rails.cache.delete("journal_entry_ids_user_#{self.id}")
  end
  
  def expire_cache
    Rails.cache.delete("j_#{self.id}")
    # remove pagination caching for cached journal list for all teams in this center
    Rails.cache.delete_matched(/journals_groups_(#{self.center_id})/)
    Rails.cache.delete_matched(/journals_all_paged_(.*)_#{REGISTRY[:journals_per_page]}/)
    # Rails.cache.delete_matched(/journal_ids_user_(.*)/)
    self.team.users.map do |user|
      (1..3).each do |i|
        Rails.cache.delete_matched(/journals_groups_#{user.center_id}_paged_#{i}_#{REGISTRY[:journals_per_page]}/)
        Rails.cache.delete_matched(/journals_groups_#{user.group_ids.join("_")}_paged_#{i}_#{REGISTRY[:journals_per_page]}/)
      end
    end
		self.team.users.map {|user| user.expire_cache}
  end
  
  def destroy_journal_entries
    self.journal_entries.compact.each { |entry| puts "Entry: #{entry.inspect}"; entry.destroy_and_remove_answers! }
  end
  
  # def destroy_person_info
  #   self.person_info.destroy if self.person_info
  # end
  
  # show all login-users for journal. Go through journal_entries
  def login_users
    self.journal_entries.collect { |entry| entry.login_user }.compact
  end
  
  # can a journal belong to one or more teams?  No, just one. Or a Center!
  def team
    return group
  end
  
  def name
    self.title
  end

  def firstname
    self.title.split(' ').first
  end
    
  def birth_short
    birthdate && birthdate.strftime("%d-%m-%Y") || ""
  end

 
  # sets the next journal code based on its center or current_user
  def next_journal_code(user)
    center = self.center && self.center || user.center
    return user.centers.map {|c| c.next_journal_code}.max if user.centers.size > 1
    center.next_journal_code
  end
  
  # returns full id, qualified with center and team ids
  def qualified_id
    qualified_code + "-" + "%04d" % self.code
  end
  
  # code of center and team
  def qualified_code
    team_id = team.code unless team.instance_of? Center
    "%04d" % center.code + "-" + "%04d" % team_id #  team.code.to_s.rjust(3, "0")
  end
  
  # creates entries with logins
  def create_journal_entries(surveys, follow_up = 0)
    return true if surveys.empty?
    surveys.each do |survey|
      entry = JournalEntry.new({:survey => survey, :state => 2, :journal => self, :follow_up => follow_up, :group_id => self.group_id})
      entry.journal_id = self.id
      # login_number = "#{self.code}#{survey.id}"
      entry.make_login_user
      entry.login_user.save && entry.save
      # if entry.valid?
      #   entry.print_login!
      #   entry.login_user.save
      # end
      # entry.expire_cache(current_user) # expire journal_entry_ids
    end
    return self
  end
    
  def header_data
    data = to_csv
    data.inject([[],[]]) do |col, tuple|
      item, val = *tuple.to_a.first
      col[0] << item
      col[1] << val
      col
    end
  end
  
  # info on journal in array of hashes
  def info
		settings = CenterSetting.find_by_center_id_and_name(self.center_id, "use_as_code_column")
    c = Dictionary.new # ActiveSupport::OrderedHash.new
    c["ssghafd"] = self.group.group_code
    c["ssghnavn"] = self.center.title
    c["safdnavn"] = self.team.title
    c["pid"] = settings && eval("self.#{settings.value}") || self.code
    c["projekt"] = self.alt_id || ""
    c["pkoen"] = self.sex
    c["palder"] = get_age(self.birthdate, self.created_at)  # alder på oprettelsesdato
    c["pnation"] = self.nationality
    c["besvarelsesdato"] = "--" # self.created_at.strftime("%d-%m-%Y")
    c["pfoedt"] = self.birthdate.strftime("%d-%m-%Y")  # TODO: translate month to danish
    c
  end
  
  # def export_info
		# settings = CenterSetting.find_by_center_id_and_name(self.center_id, "use_as_code_column")
  #   c = {}
  #   c[:ssghafd] = self.parent.group_code
  #   c[:ssghnavn] = self.center.title
  #   c[:safdnavn] = self.team.title
  #   c[:pid] = settings && eval("self.#{settings.value}") || self.code
  #   c[:projekt] = self.person_info.alt_id
  #   c[:pkoen] = self.sex
  #   c[:palder] = get_age(self.birthdate, self.created_at)  # alder på besvarelsesdatoen
  #   c[:pnation] = self.nationality
  #   c[:besvarelsesdato] = "-" #self.created_at.strftime("%d-%m-%Y")
  #   c[:pfoedt] = self.birthdate.strftime("%d-%m-%Y")  # TODO: translate month to danish
  #   c
  # end

  def get_age(birth_date, end_date)
    ( (end_date.to_datetime - birth_date).to_i / 365.25).floor
  end

  # protected
  
  # validates_presence_of   :parent,
  #                         :message => ': overordnet gruppe skal vælges',
  #                         :if => Proc.new { |group| group.class.to_s != "Center" }
                          
end
