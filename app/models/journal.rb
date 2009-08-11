require 'facets/dictionary'

class Journal < Group
  belongs_to :center
  has_one :person_info, :dependent => :destroy
  has_many :journal_entries, :order => 'created_at', :dependent => :destroy
  has_many :users, :through => :journal_entries
  has_many :surveys, :through => :journal_entries
  has_many :answered_entries,
           :class_name => 'JournalEntry',
           :include => :survey,
           :conditions => 'journal_entries.state = 5',  # answered
           :order => 'journal_entries.answered_at'
  has_many :not_answered_entries,
           :class_name => 'JournalEntry',
           :include => :survey,
           :conditions => 'journal_entries.state != 5',  # not answered
           :order => 'journal_entries.answered_at'
                 
  delegate :name, :to        => :person_info
  delegate :sex, :to         => :person_info
  delegate :birthdate, :to   => :person_info, :allow_nil => true
  delegate :nationality, :to => :person_info
  delegate :age, :to         => :person_info
  delegate :sex_text, :to    => :person_info
    
  # ID is mandatory
  validates_presence_of :code #, :message => "ID skal gives"
  validates_presence_of :name#, :message => "Navn skal angives"
  validates_presence_of :sex #, :message => "Køn skal angives"
  validates_presence_of :nationality #, :message => "Nationalitet skal angives"
  validates_associated :parent #, :message => "Et Center eller team skal angives"
  validates_presence_of :parent
  validates_associated :center
  validates_presence_of :center
  validates_presence_of :person_info
  validates_associated :person_info
  # journal code must be unique within the same center
  validates_uniqueness_of :code, :scope => :center_id #, :message => "bruges allerede. Vælg andet ID."
  
  # TODO: validates_associated or existence_of (see Advanced Rails recipes or Rails Way)
  
  named_scope :and_entries, :include => :journal_entries
  named_scope :and_person_info, :include => :person_info
  named_scope :with_parent, lambda { |group| { :conditions => ['parent_id = ?', group.is_a?(Group) ? group.id : group] } }
  named_scope :by_code, :order => 'code ASC'
  # named_scope :answers_for_surveys, lambda { |survey_ids| { :joins => {:journal_entries => :survey_answer},
  #  :conditions => ["survey_answers.survey_id IN (?)", survey_ids] } }
  

  # def validate
  #   unless self.code.to_s.size == Journal.find_by_code_and_center_id(self.code, self.center_id)
  #     errors.add("code", "skal være 4 cifre")
  #   end
  # end  
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
  
  def birthdate
    self.person_info.birthdate
  end
  
  def birth_short
    birthdate.strftime("%d-%m-%y")  
  end
  # def name
  #   self.person_info.name
  # end

  def sex_text
    PersonInfo.sexes.invert[self.sex]
  end

  def sex
    self.person_info.sex
  end

  def nationality
    self.person_info.nationality
  end
  
  # sets the next journal code based on its center or current_user
  def next_journal_code(user)
    center = user.has_access?(:center_users) && user.center || (self.center)
    center.next_journal_id if center
  end

  # returns full id, qualified with center and team ids
  def qualified_id
    team_id = if team.instance_of? Center
      "000"
    else
      team.code.to_s.rjust(3, "0")
    end
    center.code.to_s.rjust(4, "0") + "-" + team_id + "-" + self.code.to_s.rjust(4, "0")
  end
  
  # code of center and team
  def qualified_code
    team_id = if team.instance_of? Center
      "000"
    else
      team.code.to_s.rjust(3, "0")
    end
    center.code.to_s.rjust(4, "0") + "-" + team_id
  end
  
  # creates entries with logins
  def create_journal_entries(surveys)
    return true if surveys.empty?
    surveys.each do |survey|
      entry = JournalEntry.new({:journal => self, :survey => survey, :state => 2})
      entry.create_login_user
      entry.print_login! if entry.valid?
    end
  rescue 
    return false
  end

  # info on journal in array of hashes
  def info
    # h = []
    c = Dictionary.new # ActiveSupport::OrderedHash.new
    c["ssghafd"] = self.parent.group_code
    c["ssghnavn"] = self.center.title
    c["safdnavn"] = self.team.title
    c["pid"] = self.code
    c["pkoen"] = self.sex
    c["palder"] = self.age  # TODO: alder skal være alder på besvarelsesdatoen
    c["pnation"] = self.nationality
    c["dagsdato"] = self.created_at.strftime("%d-%b-%Y")
    c["pfoedt"] = self.birthdate.strftime("%d-%b-%Y")  # TODO: translate month to danish
    c
  end

  def to_csv
    info.values
  end
  
  def self.csv_header
    c = Dictionary.new
    c["ssghafd"] = nil
    c["ssghnavn"] = nil
    c["safdnavn"] = nil
    c["pid"] = nil
    c["pkoen"] = nil
    c["palder"] = nil
    c["pnation"] = nil
    c["dagsdato"] = nil
    c["pfoedt"] = nil
    c
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
  
  protected
  
  # validates_presence_of   :parent,
  #                         :message => ': overordnet gruppe skal vælges',
  #                         :if => Proc.new { |group| group.class.to_s != "Center" }
                          
end
