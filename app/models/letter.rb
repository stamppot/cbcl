class Letter < ActiveRecord::Base
  belongs_to :group
  
  validates_associated :group, :allow_blank => true
  validates_presence_of :letter
  validates_presence_of :name
  validates_presence_of :surveytype
  validates_uniqueness_of :surveytype, :scope => [:group_id, :follow_up], :message => "Der findes allerede et brev for denne skematype og opfølning for gruppen. Har du valgt den rigtige gruppe?"

  def get_follow_up
    JournalEntry.follow_ups[self.follow_up || 0].first
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
    letter = Letter.find_by_surveytype(entry.survey.surveytype, :conditions => ['group_id = ? and (follow_up = ? or follow_up is null)', entry.journal.parent_id, entry.follow_up])
    letter = Letter.find_by_surveytype(entry.survey.surveytype, :conditions => ['group_id = ? and (follow_up = ? or follow_up is null)', entry.journal.center_id, entry.follow_up]) unless letter
    # letter = Letter.find_by_surveytype(entry.survey.surveytype, :conditions => ['group_id = ?', entry.journal.parent_id]) unless letter
    # letter = Letter.find_by_surveytype(entry.survey.surveytype, :conditions => ['group_id = ?', entry.journal.center_id]) unless letter
    letter = Letter.find_default(entry.survey.surveytype) unless letter
    letter
  end

  def self.filter(options = {})
    query = ""
    query_params = []
    surveytype = options[:survey] && options[:survey][:surveytype]
    if !surveytype.blank?
      # puts "filter letter surveytype #{options[:survey][:surveytype]}"
      query << "&& " if !query.blank?
      query << "surveytype = ? "
      query_params << surveytype
    end
    group = options[:group][:id]
    if !group.blank?
      # puts "filter letter group_id #{options[:group][:id]}"
      query << "&& " if !query.blank?
      query << "group_id = ? "
      query_params << group
    end
    follow_up = options[:follow_up]
    if !follow_up.blank?
      # puts "filter letter follow_up #{options[:follow_up]}"
      query << "&& " if !query.blank?
      query << "follow_up = ? "
      query_params << follow_up
    end
    @letters = Letter.all(:conditions => [query, query_params])
  end
end
