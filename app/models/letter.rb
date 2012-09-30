class Letter < ActiveRecord::Base
  belongs_to :group
  
  validates_associated :group, :allow_blank => true
  validates_presence_of :letter
  validates_presence_of :name
  validates_presence_of :surveytype
  validates_uniqueness_of :surveytype, :scope => :group_id, :message => "Der findes allerede et brev for denne skematype for gruppen . Har du valgt den rigtige gruppe?"
  
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
    self.letter.gsub!('{{graviditetsnr}}', journal_entry.journal.person_info.alt_id || "")
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
    self.letter.gsub!('{{graviditetsnr}}', '{ MERGEFIELD graviditetsnr }')
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
end
