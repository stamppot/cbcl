class Letter < ActiveRecord::Base
  belongs_to :group
  belongs_to :center

  validates_associated :group, :allow_blank => true
  validates_presence_of :letter
  validates_presence_of :name
  validates_presence_of :surveytype
  validates_uniqueness_of :surveytype, :scope => [:group_id, :follow_up], :message => "Der findes allerede et brev for denne skematype og opfølning for gruppen. Har du valgt den rigtige gruppe?"

  named_scope :for_center, lambda { |group| { :conditions => ['center_id = ?', group.is_a?(Center) ? group.id : group] } }
  named_scope :with_cond, lambda { |cond| cond }


  def get_follow_up
    # self.follow_up ||= 0
    return "Alle" unless self.follow_up  
    JournalEntry.follow_ups[self.follow_up].first
  end

  def insert_text_variables(journal_entry)
    self.letter.gsub!('{{login}}', journal_entry.login_user.login)
    self.letter.gsub!('{{brugernavn}}', journal_entry.login_user.login)
    self.letter.gsub!('{{password}}', journal_entry.password)
    self.letter.gsub!('{{kodeord}}', journal_entry.password)
    self.letter.gsub!('{{name}}', journal_entry.journal.title)
    self.letter.gsub!('{{navn}}', journal_entry.journal.title)
    self.letter.gsub!('{{firstname}}', journal_entry.journal.firstname)
    self.letter.gsub!('{{fornavn}}', journal_entry.journal.firstname)
    self.letter.gsub!('{{mor_navn}}', journal_entry.journal.person_info.parent_name || "")
    self.letter.gsub!('{{projektnr}}', journal_entry.journal.person_info.alt_id || "")
  end
  
  def to_mail_merge
    self.letter.gsub!('{{login}}', '{ MERGEFIELD login }')
    self.letter.gsub!('{{brugernavn}}', '{ MERGEFIELD brugernavn }')
    self.letter.gsub!('{{password}}', '{ MERGEFIELD password }')
    self.letter.gsub!('{{kodeord}}', '{ MERGEFIELD kodeord }')
    self.letter.gsub!('{{name}}', '{ MERGEFIELD name }')
    self.letter.gsub!('{{navn}}', '{ MERGEFIELD navn }')
    self.letter.gsub!('{{firstname}}', '{ MERGEFIELD firstname }')
    self.letter.gsub!('{{fornavn}}', '{ MERGEFIELD fornavn }')
    self.letter.gsub!('{{mor_navn}}', '{ MERGEFIELD mor_navn }')
    self.letter.gsub!('{{projektnr}}', '{ MERGEFIELD projektnr }')
  end

  def self.find_default(surveytype)
    Letter.find_by_surveytype(surveytype, :conditions => ['group_id IS NULL or group_id = ?', 0] )
  end
  
  def self.default_letters_exist?
    Survey.surveytypes.all? { |surveytype| Letter.find_default(surveytype) }
  end
  
  def surveytype_exist
    "Der findes allerede et brev for denne skematype. Har du valgt den rigtige gruppe?"
  end

  def self.find_by_priority(entry)
    st = entry.survey.surveytype
    letter = Letter.find_by_surveytype(st, :conditions => ['group_id = ? and follow_up = ?', entry.journal.group_id, entry.follow_up])
    letter = Letter.find_by_surveytype(st, :conditions => ['group_id = ? and follow_up is null', entry.journal.group_id]) unless letter
    letter = Letter.find_by_surveytype(st, :conditions => ['group_id = ? and follow_up = ?', entry.journal.center_id, entry.follow_up]) unless letter
    letter = Letter.find_by_surveytype(st, :conditions => ['group_id = ? and follow_up is null', entry.journal.center_id]) unless letter
    letter = Letter.find_default(st) unless letter
    letter
  end

  def self.get_conditions(surveytype = nil, group_id = nil, follow_up = nil, include_null = false)
    query = [""]
    if !surveytype.blank?
      # puts "filter letter surveytype #{options[:survey][:surveytype]}"
      s_query = (!query.first.blank? ? "and surveytype = ? " : "surveytype = ? ")
      s_query << "or surveytype is null " if include_null
      query.first << s_query
      query << surveytype
    end
    if !group_id.blank?
      # puts "filter letter group_id #{options[:group][:id]}"
      g_query = (!query.first.blank? ? "and group_id = ? " : "group_id = ? ")
      query.first << g_query
      query << group_id
    end
    puts "follow_up: #{follow_up}"
    if !follow_up.blank?
      # puts "filter letter follow_up #{options[:follow_up]}"
      f_query = (!query.first.blank? ? "and follow_up = ? " : "follow_up = ? ")
      f_query = "or follow_up is null" if include_null
      query.first << f_query
      query << follow_up
    end
    {:conditions => query}
#    @letters = Letter.all(:conditions => query)
  end


  def self.filter(options = {})
    surveytype = options[:survey] && options[:survey][:surveytype]
    group_id = options[:group] && options[:group][:id]
    follow_up = options[:follow_up] && !options[:follow_up][:follow_up].blank? && options[:follow_up][:follow_up].to_i
    query = [""]
    cond = Letter.get_conditions(surveytype, group_id, follow_up)
    @letters = Letter.for_center(options[:center_id]).with_cond(cond)
  end
end
