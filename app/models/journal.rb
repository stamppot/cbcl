# encoding: utf-8
# require 'facets/dictionary'
#require 'rake'
# require 'hashery'
class Journal < Group
  belongs_to :center
  has_one :person_info #, :dependent => :destroy
  # has_many :journal_entries, :order => 'created_at', :dependent => :destroy
  has_many :journal_entries, :order => 'created_at', :dependent => :destroy
  has_many :login_users, :through => :journal_entries, :source => :journal_entries
  has_many :surveys, :through => :journal_entries
  has_many :survey_answers
  has_many :csv_answers
  has_many :score_rapports, :through => :survey_answers
  has_and_belongs_to_many :projects
  
  
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
  delegate :birthdate, :to   => :person_info, :allow_nil => true
  delegate :nationality, :to => :person_info
  delegate :age, :to         => :person_info
  delegate :sex_text, :to    => :person_info
  
  after_save    :expire_cache
	after_create  :index_search, :expire_cache
  after_destroy :expire_cache
  after_destroy :destroy_journal_entries
  after_destroy :destroy_person_info
  
  # ID is mandatory
  validates_presence_of :code #, :message => "ID skal gives"
  validates_presence_of :name#, :message => "Navn skal angives"
  validates_presence_of :sex #, :message => "Køn skal angives"
  validates_presence_of :nationality #, :message => "Nationalitet skal angives"
  validates_associated :parent #, :message => "Et Center eller team skal angives"
  validates_presence_of :parent
  validates_associated :center
  validates_presence_of :center
  # validates_presence_of :person_info
  # validates_associated :person_info
  # journal code must be unique within the same center
  validates_uniqueness_of :code, :scope => :center_id #, :message => "bruges allerede. Vælg andet ID."
  # TODO: validates_associated or existence_of (see Advanced Rails recipes or Rails Way)
  
  named_scope :and_entries, :include => :journal_entries
  # named_scope :and_login_users, :include => { :journal_entries => :login_user }
  named_scope :and_person_info, :include => :person_info
  named_scope :for_parent, lambda { |group| { :conditions => ['parent_id = ?', group.is_a?(Group) ? group.id : group], :order => 'created_at desc' } }
  named_scope :for_center, lambda { |group| { :conditions => ['center_id = ?', group.is_a?(Center) ? group.id : group], :order => 'created_at desc' } }
  named_scope :by_code, :order => 'code ASC'
  named_scope :for_groups, lambda { |group_ids| { :conditions => ['parent_id IN (?)', group_ids] } }
  named_scope :for, lambda { |journal_id| { :conditions => ['id = ?', journal_id] } }
  
  
  define_index do
     # fields
     indexes :title, :sortable => true
     indexes :code, :sortable => true
     indexes person_info.cpr, :as => :person_info_cpr
		 # indexes center_id
     # attributes
     has parent_id, center_id, created_at, updated_at

     set_property :delta => true
   end

  # def validate
  #   unless self.code.to_s.size == Journal.find_by_code_and_center_id(self.code, self.center_id)
  #     errors.add("code", "skal være 4 cifre")
  #   end
  # end 

  def self.search_journals(user, phrase)
    journals =
    if phrase.empty?
      []
    elsif user.has_role?(:superadmin)
      Journal.search(phrase, :order => "created_at DESC", :include => :person_info, :per_page => 40)
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

  def get_project_code
    projects.any? && projects.first.code || ""
  end
  
  def get_name
    person_info && person_info.name || title # .force_encoding("UTF-8")
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
		self.team.users.map {|user| user.expire_cache}
  end
  
  def destroy_journal_entries
    self.journal_entries.each { |entry| entry.destroy_and_remove_answers! }
  end
  
  def destroy_person_info
    self.person_info.destroy
  end
  
  # show all login-users for journal. Go through journal_entries
  def login_users
    self.journal_entries.collect { |entry| entry.login_user }.compact
  end
  
  # can a journal belong to one or more teams?  No, just one. Or a Center!
  def team
    return parent
  end
  
  def name
    self.title
  end

  def firstname
    self.title.split(' ').first
  end
  
  def birthdate
    self.person_info && self.person_info.birthdate
  end
  
  def birth_short
    birthdate && birthdate.strftime("%d-%m-%Y") || ""
  end

  def sex_text
    PersonInfo.sexes.invert[self.sex]
  end

  def sex
    self.person_info && self.person_info.sex
  end

  def nationality
    self.person_info && self.person_info.nationality
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
      entry = JournalEntry.new({:survey => survey, :state => 2, :journal => self, :follow_up => follow_up, :group_id => self.parent_id})
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
    c["ssghafd"] = self.parent.group_code
    c["ssghnavn"] = self.center.title
    c["safdnavn"] = self.team.title
    c["pid"] = settings && eval("self.#{settings.value}") || self.code
    c["alt_id"] = self.person_info.alt_id || ""
    c["pkoen"] = self.sex
    c["palder"] = self.age  # TODO: alder skal være alder på besvarelsesdatoen
    c["pnation"] = self.nationality
    c["dagsdato"] = self.created_at.strftime("%d-%m-%Y")
    c["pfoedt"] = self.birthdate.strftime("%d-%m-%Y")  # TODO: translate month to danish
    c
  end
  
  def export_info
		settings = CenterSetting.find_by_center_id_and_name(self.center_id, "use_as_code_column")
    c = {}
    c[:ssghafd] = self.parent.group_code
    c[:ssghnavn] = self.center.title
    c[:safdnavn] = self.team.title
    c[:pid] = settings && eval("self.#{settings.value}") || self.code
    c[:alt_id] = self.person_info.alt_id
    c[:pkoen] = self.sex
    c[:palder] = self.age  # TODO: alder skal være alder på besvarelsesdatoen
    c[:pnation] = self.nationality
    c[:dagsdato] = self.created_at.strftime("%d-%m-%Y")
    c[:pfoedt] = self.birthdate.strftime("%d-%m-%Y")  # TODO: translate month to danish
    c
  end

  # protected
  
  # validates_presence_of   :parent,
  #                         :message => ': overordnet gruppe skal vælges',
  #                         :if => Proc.new { |group| group.class.to_s != "Center" }
                          
end
