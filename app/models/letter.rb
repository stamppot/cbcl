class Letter < ActiveRecord::Base
  belongs_to :group
  
  validates_associated :group, :allow_blank => true
  validates_presence_of :letter
  validates_presence_of :name
  validates_presence_of :surveytype
  # validates_uniqueness_of :surveytype, :scope => :group
  
  def insert_text_variables(journal_entry)
    self.letter.gsub!('{{login}}', journal_entry.login_user.login)
    self.letter.gsub!('{{brugernavn}}', journal_entry.login_user.login)
    self.letter.gsub!('{{password}}', journal_entry.password)
    self.letter.gsub!('{{kodeord}}', journal_entry.password)
    self.letter.gsub!('{{name}}', journal_entry.journal.title)
    self.letter.gsub!('{{navn}}', journal_entry.journal.title)
    self.letter.gsub!('{{firstname}}', journal_entry.journal.firstname)
    self.letter.gsub!('{{fornavn}}', journal_entry.journal.firstname)
  end
  
  def self.find_default(surveytype)
    Letter.find_by_surveytype(surveytype, :conditions => ['group_id IS NULL or group_id = ?', 0] )
  end
  
  def self.default_letters_exist?
    Survey.surveytypes.all? { |surveytype| Letter.find_default(surveytype) }
  end
end
