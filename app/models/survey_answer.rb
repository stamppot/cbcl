require 'facets/dictionary'

class SurveyAnswer < ActiveRecord::Base
  has_many :answers, :dependent => :destroy, :include => [ :answer_cells ], :order => :number
  #belongs_to :journal_entry
  has_one :journal_entry
  belongs_to :survey
  has_one :score_rapport

  named_scope :finished, :conditions => ['done = ?', true]
  named_scope :order_by, lambda { |column| { :order => column } }
  named_scope :and_answer_cells, :include => { :answers => :answer_cells }
  named_scope :between, lambda { |start, stop| { :conditions => { :created_at  => start..stop } } }
  named_scope :aged_between, lambda { |start, stop| { :conditions => { :age  => start..stop } } }
  named_scope :from_date, lambda { |start| { :conditions => { :created_at  => start..(Date.now) } } }
  named_scope :to_date, lambda { |stop| { :conditions => { :created_at  => (Date.now)..stop } } }
  named_scope :for_surveys, lambda { |survey_ids| { :conditions => ["survey_answers.survey_id IN (?)", survey_ids] } }
  named_scope :for_survey_answers, lambda { |survey_answer_ids| { :conditions => ["survey_answers.id IN (?)", survey_answer_ids] } }
  named_scope :for_survey, lambda { |survey_id| { :conditions => ["survey_answers.survey_id = ?", survey_id] } }
  named_scope :with_journals, :joins => "INNER JOIN `journal_entries` ON `journal_entries`.journal_id = `journal_entries`.survey_answer_id", :include => {:journal_entry => :journal}

  def answered_by_role
    return Role.get(self.answered_by)
  end

  def to_csv
    self.survey.cell_variables.merge!(self.cell_values(self.survey.prefix)).values #.join(';')
  end

  def cell_values(prefix = nil)
    prefix ||= self.survey.prefix
    a = Dictionary.new
    self.answers.each { |answer| a.merge!(answer.cell_values(prefix)) }
    a.order_by
  end
  
  # cascading does not work over multiple levels, ie. answer_cells are not deleted
  def delete
    # better solution: iterate through answers, do cascading delete
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
  
  def add_missing_cells
    self.max_answer.add_missing_cells
  end
  
  def sex
    PersonInfo.sexes.invert[self.sex]
  end
  
  # get all scores related to this survey answer.
  def scores
    Survey.find(survey_id, :include => { :scores => :score_items } ).scores
  end

  def calculate_score
    rapport = ScoreRapport.find_or_create_by_survey_answer_id(self.id)
    rapport.update_attributes(:survey_name => self.survey.title, :survey => self.survey)
    
    journal = self.journal_entry.journal
    scores = self.survey.scores
    scores.each do |score|
      score_result = ScoreResult.find(:first, :conditions => ['score_id = ? AND score_rapport_id = ?', score.id, rapport.id])
      
      args = { :title => score.title, :score_id => score.id, :scale => score.scale, :survey => self.survey,
            :result => score.result(self, journal), :percentile => score.percentile(self, journal), :score_rapport => rapport, :position => score.position }
      if score_result
        score_result.update_attributes(args)
      else
        score_result = ScoreResult.create(args)
      end
      rapport.short_name = score.short_name
    end
    rapport.save
    return rapport
  end
        
  # print all values iteratively
  def print
    output = "Survey Answer: #{self.survey.title}<br>"
    answers.each { |answer| output << answer.print }
    return output
  end
  
  def answer_exists?(number)
    Answer.find(:first, :conditions => ['survey_answer_id = ? and number = ?', self.id, number.to_i])
  end
  
  def save_partial_answers(params, survey)
    # remove empty answers
    params.each do |key, cells|
      if key =~ /Q\d+/ && (cells.nil? || (cells.size == 1 && cells.has_key?("id")))
          params.delete(key)
      end
    end
    params.each_key { |question| params.delete(question) if params[question].empty? }

    # check valid values from survey
    valid_values = survey.valid_values
    answers_to_save = []
    # param_array = params.to_a
    params.each do |key, q_cells|   # one question at a time
      if key.include? "Q"
        q_id = q_cells.delete("id")
        q_number = key.split("Q").last

        # find existing answer or create new
        an_answer = self.answer_exists?(q_number) || Answer.create(:survey_answer_id => self.id,
          :question_id => q_id,
          :number => q_number.to_i)

        new_cells = {}

        q_cells.each do |cell, value|
          if cell =~ /q(\d+)_(\d+)_(\d+)/      # match col, row
            q = "Q#{$1}"
            a_cell = {:value => value, :row => $2.to_i, :col => $3.to_i}

            # if answer_cell exists, just update its value
            if answer_cell = an_answer.answer_cell_exists?(a_cell[:col], a_cell[:row])
              answer_cell.change_value(value, valid_values[q][cell]) # was with !
            else  # new answer_cell
              new_cells[cell] = a_cell
            end
          end
        end
        # create answer cells from cell hashes
        an_answer.create_cells(new_cells, valid_values[key])
        answers_to_save << an_answer
        new_cells.clear
      end
      # commit/save all answer_cells
      transaction do
        answers_to_save.each do |a| 
          a.answer_cells.each do |ac|
            ac.save! if ac.new_record? || ac.changed?
          end
        end
      end
    end
  end
end
