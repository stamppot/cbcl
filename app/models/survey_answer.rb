# require 'facets/dictionary'
require 'ar-extensions/adapters/mysql'
require 'ar-extensions/import/mysql'

class SurveyAnswer < ActiveRecord::Base
  has_many :answers, :dependent => :destroy, :include => [ :answer_cells ], :order => :number
  #belongs_to :journal_entry
  has_one :journal_entry
  belongs_to :survey
  has_one :score_rapport
  has_one :csv_answer
  belongs_to :journal
  
  named_scope :finished, :conditions => ['done = ?', true]
  named_scope :order_by, lambda { |column| { :order => column } }
  named_scope :and_answer_cells, :include => { :answers => :answer_cells }
  named_scope :between, lambda { |start, stop| { :conditions => { :created_at  => start..stop } } }
  named_scope :aged_between, lambda { |start, stop| { :conditions => { :age  => start..stop } } }
  named_scope :from_date, lambda { |start| { :conditions => { :created_at  => start..(Date.now) } } }
  named_scope :to_date, lambda { |stop| { :conditions => { :created_at  => (Date.now)..stop } } }
  named_scope :for_surveys, lambda { |survey_ids| { :conditions => ["survey_answers.survey_id IN (?)", survey_ids] } }
  named_scope :for_survey, lambda { |survey_id| { :conditions => ["survey_answers.survey_id = ?", survey_id] } }
  named_scope :with_journals, :joins => "INNER JOIN `journal_entries` ON `journal_entries`.journal_id = `journal_entries`.survey_answer_id", :include => {:journal_entry => :journal}
  named_scope :for_entries, lambda { |entry_ids| { :conditions => ["survey_answers.journal_entry_id IN (?)", entry_ids] } }

  def answered_by_role
    return Role.get(self.answered_by)
  end

  def to_csv
    self.survey.cell_variables.merge!(self.cell_values(self.survey.prefix)).values
  end

  def save_all(params)
    # if answered by other, save the textfield instead
    # "answer"=>{"person_other"=>"fester", "person"=>"15"}
    if params[:answer] && (other = params[:answer][:person_other]) && !other.blank? && (other.to_i == Role.get(:other).id)
      self.answered_by = other
    end
    self.answered_by = params[:answer] && params[:answer][:person] || ""
    self.done = true
    self.save   # must save here, otherwise partial answers cannot be saved becoz of lack of survey_answer.id
    self.save_answers(params)
    self.answers.each { |a| a.update_ratings_count }
    Answer.transaction do
      answers.each {|a| a.save!}
    end
      # survey_answer.add_missing_cells unless current_user.login_user # 11-01-10 not necessary with ratings_count
    spawn do
      self.create_csv_answer
    end
    self.save
  end
  
  def create_csv_answer
    CSVHelper.new.create_csv_answer(self)
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

  # returns array of cells that must be saved
  def add_missing_cells_optimized
    self.max_answer.add_missing_cells_optimized
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
      
      args = { 
        :title => score.title, 
        :score_id => score.id, 
        :scale => score.scale, 
        :survey => self.survey,
        :result => score.result(self, journal), 
        :percentile => score.percentile(self, journal), 
        :score_rapport => rapport, 
        :position => score.position
      }

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
  
  def save_answers(params)
    params.each do |key, cells|
      if key =~ /Q\d+/ && (cells.nil? || (cells.size == 1 && cells.has_key?("id")))
          params.delete(key)
      end
    end
    params.each_key { |question| params.delete(question) if params[question].empty? }
    the_valid_values = Rails.cache.fetch("survey_valid_values_#{self.survey_id}") { self.survey.valid_values }
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
          a_cell = {:answer_id => an_answer.id, :row => $2.to_i, :col => $3.to_i, :value => value}
          if answer_cell = an_answer.exists?(a_cell[:row], a_cell[:col]) # update
            update_cells << [answer_cell.id,  answer_cell.value] if answer_cell.change_value(value, the_valid_values[q][cell])
          else
            new_cells[cell] = a_cell  # insert
          end
        end
      end
      insert_cells += an_answer.create_cells_optimized(new_cells, the_valid_values[key])
      new_cells.clear
    end
    columns = [:answer_id, :row, :col, :item, :answertype, :value]
    t = Time.now; new_cells_no = AnswerCell.import(columns, insert_cells, :on_duplicate_key_update => [:value]); e = Time.now
    puts "MASS IMPORT ANSWER CELLS (#{new_cells_no.num_inserts}): #{e-t}"

    t = Time.now; updated_cells_no = AnswerCell.import([:id, :value], update_cells, :on_duplicate_key_update => [:value]); e = Time.now
    puts "MASS IMPORT (update) ANSWER CELLS (#{updated_cells_no.num_inserts}): #{e-t}"
    return self
  end
  
  private
  #INSERT INTO `answer_cells` (`answer_id`,`row`,`col`,`item`,`answertype`,`value`) VALUES (27656,1,2,'1','ListItem','14+%C3%A5r'),(27657,1,2,'1','Rating','2'),(27658,1,2,'1','ListItem','14+timer') ON DUPLICATE KEY UPDATE `answer_cells`.`value`=VALUES(`value`)
  
  # def mass_insert!(new_cells)
  #   return if new_cells.nil?
  #   inserts = []
  #   new_cells.flatten.compact.each do |c|
  #     inserts.push "(#{c.col}, NULL, #{c.row}, '#{c.value}', #{c.answer_id}, '#{c.item}')" # (1, NULL, 1, '9', 27484, '1')
  #   end 
  #   sql_insert = "INSERT INTO `answer_cells` (`col`, `answertype`, `row`, `value`, `answer_id`, `item`) VALUES #{inserts.join(", ")};\n" if inserts.any?
  #   no_cells = new_cells.size
  #   inserts.clear
  #   ActiveRecord::Base.connection.execute sql_insert unless sql_insert.blank?
  #   # logger.info "update: #{sql_update}"
  # end
  
end
