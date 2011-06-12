require 'facets/dictionary'
require 'ar-extensions/adapters/mysql'
require 'ar-extensions/import/mysql'

class SurveyAnswer < ActiveRecord::Base
  include ModelMixins::SurveyAnswer::Export
  belongs_to :survey
  belongs_to :journal
  belongs_to :center
  has_many :answers, :dependent => :destroy, :include => [ :answer_cells ], :order => :number
  #belongs_to :journal_entry
  has_one :journal_entry
  has_one :score_rapport
  has_one :csv_answer
  
  named_scope :finished, :conditions => ['done = ?', true]
  named_scope :order_by, lambda { |column| { :order => column } }
  named_scope :and_answer_cells, :include => { :answers => :answer_cells }
  named_scope :between, lambda { |start, stop| { :conditions => { :created_at  => start..stop } } }
  named_scope :aged_between, lambda { |start, stop| { :conditions => { :age  => start..stop } } }
  named_scope :from_date, lambda { |start| { :conditions => { :created_at  => start..(Date.now) } } }
  named_scope :to_date, lambda { |stop| { :conditions => { :created_at  => (Date.now)..stop } } }
  named_scope :for_surveys, lambda { |survey_ids| { :conditions => { :survey_id => survey_ids } } }
  named_scope :for_survey, lambda { |survey_id| { :conditions => ["survey_answers.survey_id = ?", survey_id] } }
  named_scope :with_journals, :joins => "INNER JOIN `journal_entries` ON `journal_entries`.journal_id = `journal_entries`.survey_answer_id", :include => {:journal_entry => :journal}
  named_scope :for_entries, lambda { |entry_ids| { :conditions => { :journal_entry_id => entry_ids } } } # ["survey_answers.journal_entry_id IN (?)", 

  validates_presence_of :journal_id
  validates_presence_of :survey_id
  validates_presence_of :journal_entry_id
  validates_presence_of :center_id
  validates_associated :journal
  validates_associated :center
  validates_associated :journal_entry

  def answered_by_role
    return Role.get(self.answered_by)
  end

  def to_csv
    self.survey.cell_variables.merge!(self.cell_values(self.survey.prefix)).values
  end

  def save_final(params, save_the_answers = true)
		set_answered_by(params)
    self.done = true
    self.save   # must save here, otherwise partial answers cannot be saved becoz of lack of survey_answer.id
    self.save_answers(params) if save_the_answers
    # self.answers.each { |a| a.update_ratings_count }
    Answer.transaction do
      answers.each {|a| a.save!}
    end

    spawn do
      self.generate_score_rapport(update = true) # generate score report
      self.create_csv_answer!
    end
    self.save
  end
  
	def set_answered_by(params = {})
    # if answered by other, save the textfield instead    # "answer"=>{"person_other"=>"fester", "person"=>"15"}
    if params[:answer] && (other = params[:answer][:person_other]) && !other.blank? && (other.to_i == Role.get(:other).id)
      self.answered_by = other
    end
    self.journal_entry_id = self.journal_entry.id if journal_entry_id == 0
    self.answered_by = params[:answer] && params[:answer][:person] || ""
	end
	
	def all_answered?
		self.no_unanswered == 0
	end
  
  def delete
    answers = self.answers
    answers.each { |answer| Answer.find(answer.id).destroy }  # deletes answers and answer cells
    SurveyAnswer.destroy self.id
  end
  
  def sort_answers
    self.answers.sort
  end

  def max_answer
    self.answers.max {|q,p| q.count_items <=> p.count_items }
  end

  def no_unanswered
    # count values in largest answer
    answer = self.max_answer # answers.detect {|answer| answer.question_id == score_item.question_id }
    answer && answer.ratings_count || 0 # 11-01-10 was answer.not_answered_ratings
  end
  
  def sex
    PersonInfo.sexes.invert[self[:sex]]
  end
  
  # get all scores related to this survey answer.
  def scores
    Survey.find(survey_id, :include => { :scores => :score_items } ).scores
  end

  def generate_score_report(update = false)
    ScoreRapport.create_or_update(self, survey, journal, no_unanswered, created_at, update)
  end
    
  # print all values iteratively
  def print
    output = "Survey Answer: #{self.survey.title}<br>"
    answers.each { |answer| output << answer.print }
    return output
  end
  
  def save_answers(params)
    params.each do |key, cells|
      if key =~ /Q\d+/ && (cells.nil? || (cells.size == 1 && cells.has_key?("id")))
        params.delete(key)
      end
    end
    params.each_key { |question| params.delete(question) if params[question].empty? }
    variables = cache_fetch("variables_in_hash") { Variable.all_in_hash(:by => 'question_id') }
    the_valid_values = cache_fetch("survey_valid_values_#{self.survey_id}") { survey.valid_values }
    insert_cells = []
    update_cells = []
    
    params.each do |key, q_cells|   # one question at a time
      next unless key.include? "Q"
      q_id = q_cells.delete("id")
      q_number = key.split("Q").last
      an_answer = self.answers.find_or_create_by_survey_answer_id_and_number(:survey_answer_id => self.id, :question_id => q_id, :number => q_number.to_i)
      new_cells ||= {}
      q_cells.each do |cell, value|
        if cell =~ /q(\d+)_(\d+)_(\d+)/   # match col, row
          q = "Q#{$1}"
          row, col = $2.to_i, $3.to_i
          a_cell = {:answer_id => an_answer.id, :row => row, :col => col, :value => value, :variable_id => variables[q_id.to_i][row][col].id}
          if answer_cell = an_answer.exists?(a_cell[:row], a_cell[:col]) # update
            update_cells << [answer_cell.id,  answer_cell.value, answer_cell.value_text] if answer_cell.change_value(value, the_valid_values[q][cell])
          else
            new_cells[cell] = a_cell  # insert
          end
        end
      end
      insert_cells += an_answer.create_cells_optimized(new_cells, the_valid_values[key])
      new_cells.clear
    end
    # columns = [:answer_id, :row, :col, :item, :answertype, :value, :rating, :text, :value_text, :cell_type]
    columns = [:answer_id, :row, :col, :item, :value, :rating, :text, :value_text, :cell_type, :variable_id]
    new_cells_no = AnswerCell.import(columns, insert_cells, :on_duplicate_key_update => [:value, :value_text])
    updated_cells_no = AnswerCell.import([:id, :value, :value_text], update_cells, :on_duplicate_key_update => [:value, :value_text])
    # puts "MASS IMPORT (update) ANSWER CELLS (#{updated_cells_no.num_inserts}): #{e-t}"
    self.answers.each { |a| a.update_ratings_count }
    return self
  end
  
end
