# encoding: utf-8

class Survey < ActiveRecord::Base
  has_many :questions, :dependent => :destroy, :include => [ :question_cells ], :order => 'number ASC'
  has_many :subscriptions  # this not needed?
  has_many :centers, :through => :subscriptions
  has_many :survey_answers, :through => :journal_entries
  has_many :journals, :through => :journal_entries
  has_many :scores
  has_many :variables # not needed

  named_scope :and_questions, :include => {:questions => :question_cells}
  named_scope :and_q, :include => :questions
  named_scope :selected, lambda { |ids| { :conditions => (ids ? ['id IN (?)', ids] : []) } }
  # named_scope :by_question_id, lambda {|question| { :conditions => ['id = ?', question.is_a?(Question) ? question.id : question] } }
  
  validates_presence_of :position
  
  attr_accessor :selected
  # includes cells

  def get_title
    title.force_encoding("UTF-8")
  end
  
  def description
    attributes["description"].force_encoding("UTF-8")
  end
  
  def valid_values
    params = {}
    self.questions.each do |question|
      params["Q#{question.number}"] = question.valid_values
    end
    return params
  end
  
  def no_questions
    Question.by_survey(self.id).count #(:conditions => ['survey_id = ?', self.id]) # self.questions.count
  end
  
  def sort_questions
    Question.and_question_cells.by_survey(self.id).find(:all, :order => 'number ASC') # used for showing survey, so preload
  end
    
  def new_question_number
    no_questions = [0]
    no_questions << Question.by_survey(self.id).maximum(:number) #, :conditions => ['survey_id = ?', self.id])
    no_questions.delete(nil)
    return no_questions.max + 1
  end
  
  def merge_survey_answer(survey_answer)
    return self if survey_answer.nil?
    survey_answer.answers.each do |answer|
      # find question which matches answer
      question = self.questions.detect { |question| question.id == answer.question_id }
      question.merge_answer(answer) if question
    end
    return self  # return survey with questions with values (answers)
  end

  def merge_report_answer(survey_answer)
    return {} if survey_answer.nil?
    questions = Dictionary.new
    self.questions.sort_by {|q| q.number}.each do |question|
      answer = survey_answer.answers.detect {|answer| question.id == answer.question_id }
      questions[question] = question.merge_report_answer(answer) if answer
    end
    return questions   # return survey with questions with values (answers)
  end

  # users that can answer a given survey
  def answer_by
    roles = []
    roles << Role.get(self.surveytype)
    # teacher survey can be answered by pedagogue and vice-versa
    case self.surveytype
    when "teacher"   then roles << Role.get(:pedagogue)
    when "pedagogue" then roles << Role.get(:teacher)
    end
    roles << Role.get(:other)
    roles = roles.map { |r| [I18n.translate("roles.#{r.title}"), r.id] }
  end
  
  def question_with_most_items
    self.questions.max {|q,p| q.count_items <=> p.count_items }
  end
  alias :max_question :question_with_most_items
  
  # return range of valid ages
  # age is fx "4-10"
  def age_group
    years = age.split("-")
    return Range.new(years.first.to_f, years.last.to_f)
  end
  
  # shortest name used for prefix for statistics variables
  def prefix
    pre = case id
    when 1 then "cc"  # cbcl 1,5-5 # change
    when 2 then "ccy" # CBCL 6-16
    when 3 then "ct"  # CTRF pædagog 1,5-5
    when 4 then "tt"  # TRF lærer 6-16
    when 5 then "ycy" # YSR 6-16
    end
    return pre
  end

  # set variable values in survey's question cells. Use vars when they exist, otherwise create a value
  def set_variables
    d = Dictionary.new
    self.questions.each { |question| question.set_variables }
    d.order_by
  end

  def get_variables # do not cache, coz the cells are merged with answer cells
    d = Dictionary.new
    self.questions.each { |question| d = d.merge!(question.get_variables(self.prefix)) }
    d.order_by
  end
    
  def cell_variables # do not cache, coz the cells are merged with answer cells
    d = Dictionary.new
    self.questions.each { |question| d = d.merge!(question.cell_variables(self.prefix)) }
    d.order_by
  end

  def csv_headers
    s = Survey.and_questions.find(self.id)
    s.cell_variables.keys
  end
  
  # export to xml. Recurses through objects
  # add indentation when one object in the array is an array (of answers)
  def to_xml2
    xml = []
    xml << "<survey id='#{self.id.to_s}' >"
    xml << "  <name>#{self.name}</name>"
    xml << "  <description>#{self.description}</description>"
    xml << "  <type>#{self.surveytype}</type>"
    xml << "  <questions>"
    xml << questions.collect { |question| question.to_xml }
    xml << "  </questions>"
    xml << "</survey>"
  end
  
  def self.get_survey_type(surveytype)
    Survey.SURVEY_TYPES.rassoc(surveytype).first
  end
  
  def Survey.SURVEY_TYPES
    [ ["Lærer", "teacher"], ["Forælder", "parent"], ["Barn", "youth"], ["Pædagog", "pedagogue"], ["Andet", "other"] ]
   end
   
  # expand label the same way as rating, to choose between multiple labels
  # change to include (value, text) pairs
  # angiv tydeligt om feltet kan besvares
  def Survey.OPTIONS
    [ ["Spørgsmål", "Text"], ["Svarboks", "TextBox"], ["Tekst/svar-felt", "ListItem"], ["Tekst + svar-felt", "ListItemx2"], ["Tekst + svarboks", "ListItemComment"],
    ["Valgliste", "SelectList"], ["Tekst + valgliste", "ListItem_SelectList"],
    ["Rating 0..1", "Rating0_2"], ["Rating 0..2", "Rating0_3"], ["Rating 1..3", "Rating1_3"],
    ["Rating 0-index", "Rating_0"], ["Rating 1-index", "Rating_1"],
    ["Check Ingen", "CheckboxAccess"], ["Check tekst", "Checkbox"],
    ["Infoboks", "Information"], ["(tom)", "Placeholder"],
    ["Beskrivelse 2", "Description_2"], ["Beskrivelse 3", "Description_3"], ["Beskrivelse 4", "Description_4"],
    ["Beskrivelse 5", "Description_5"], ["Beskrivelse 6", "Description_6"], ["Beskrivelse 7", "Description_7"] ] #if OPTIONS.nil?
  end
  
  def Survey.ANSWER_ITEMS
    [ ["No", "Number"], ["abc", "Letter"] ]
  end
  
  def Survey.surveytypes
    ["parent", "teacher", "pedagogue", "youth" ]
  end
end
