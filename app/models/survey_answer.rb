# require 'facets/dictionary'
require 'ar-extensions/adapters/mysql'
require 'ar-extensions/import/mysql'

class SurveyAnswer < ActiveRecord::Base
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

  def answered_by_role
    return Role.get(self.answered_by)
  end

  def to_csv
    self.survey.cell_variables.merge!(self.cell_values(self.survey.prefix)).values
  end

  def save_draft(params, save_the_answers = true)
		set_answered_by(params)
    self.done = false
    self.save   # must save here, otherwise partial answers cannot be saved becoz of lack of survey_answer.id
    self.save_answers(params) if save_the_answers
    # self.answers.each { |a| a.update_ratings_count }
    Answer.transaction do
      answers.each {|a| a.save!}
    end
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
      # survey_answer.add_missing_cells unless current_user.login_user # 11-01-10 not necessary with ratings_count
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

	# doesn't work?!  # 14-11-2011
	def all_answered?
		self.no_unanswered == 0
	end
	
	def get_variables # do not cache, coz the cells are merged with answer cells
    d = Dictionary.new
    self.answers.each { |answer| d = d.merge!(answer.get_variables(survey.prefix)) }
    d.order_by
  end
  
  def cell_values(prefix = nil)
    prefix ||= self.survey.prefix
    a = Dictionary.new
    self.answers.each { |answer| a.merge!(answer.cell_values(prefix)) }
    a.order_by
  end
  
  def cell_vals(prefix = nil)
    prefix ||= self.survey.prefix
    a = []
    self.answers.each { |answer| a << (answer.cell_vals(prefix)) }
    a
    # a.order_by
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

  def no_unanswered
    # count values in largest answer
    answer = self.max_answer # answers.detect {|answer| answer.question_id == score_item.question_id }
    return answer.ratings_count if answer # 11-01-10 was answer.not_answered_ratings
    return 0
  end

  # returns array of cells that must be saved
  # def add_missing_cells_optimized
  #   self.max_answer.add_missing_cells_optimized
  # end
  
  def add_missing_cells
    self.max_answer.add_missing_cells
  end
  
  def sex
    PersonInfo.sexes.invert[self[:sex]]
  end
  
  # get all scores related to this survey answer.
  def scores
    Survey.find(survey_id, :include => { :scores => :score_items } ).scores
  end

  def generate_score_report(update = false)
    rapport = ScoreRapport.find_by_survey_answer_id(self.id, :include => {:survey_answer => {:journal => :person_info}})
    args = { :survey_name => self.survey.title,
                  :survey => self.survey,
              :unanswered => self.no_unanswered,
              :short_name => self.survey.category,
                     :age => self.journal.person_info.age,
                  :gender => self.journal.person_info.sex,
               :age_group => self.survey.age,
              :created_at => self.created_at,  # set to date of survey_answer
               :center_id => self.center_id,
        :survey_answer_id => self.id
            }
            
    rapport = ScoreRapport.create(args) unless rapport
    rapport.update_attributes(args) if update && !rapport.new_record?
    
    scores = self.survey.scores
    scores.each do |score|
      score_result = ScoreResult.find(:first, :conditions => ['score_id = ? AND score_rapport_id = ?', score.id, rapport.id])
      
      # everything is calculated already
      if !update && score_result && score_result.valid_percentage && !score_result.title && !score_result.scale && !score_result.result && !score_result.percentile && !score_result.percentile_98 && 
        !score_result.percentile_95 && !score_result.deviation 
        next
      else
        result, percentile, mean, missing, hits, age_group = score.calculate(self)
        score_ref = score.find_score_ref(self.journal)
        # ADHD score (id: 57 has no items)
        missing_percentage = if score.items_count.blank? or score.items_count == 0
          99.99
        else
          ((missing.to_f / score.items_count.to_f) * 100.0).round(2)
        end          
        # puts "sc: #{score.title} items: #{score.items_count} sr: #{score_result.id} miss: #{missing}  score: #{score.id} sa_id: #{self.id}"
        # puts "perc: #{missing_percentage} "
        
        args = { 
          :title => score.title, 
          :score_id => score.id, 
          :scale => score.scale, 
          :survey => self.survey,
          :result => result, 
          :percentile_98 => (percentile == :percentile_98),
          :percentile_95 => (percentile == :percentile_95),
          :deviation => (percentile == :deviation),
          :score_rapport => rapport, 
          :mean => mean,
          :position => score.position,
          :score_scale_id => score.score_scale_id,
          :hits => hits,
          :missing => missing,
          :missing_percentage => missing_percentage, 
          :valid_percentage => (missing_percentage <= 10.0)
        }
        
        if score_result
          score_result.update_attributes(args)
        else
          score_result = ScoreResult.create(args)
        end
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
    the_valid_values = cache_fetch("survey_valid_values_#{self.survey_id}") { self.survey.valid_values }
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
    columns = [:answer_id, :row, :col, :item, :value, :rating, :text, :value_text, :cell_type]
    t = Time.now; new_cells_no = AnswerCell.import(columns, insert_cells, :on_duplicate_key_update => [:value, :value_text]); e = Time.now
    # puts "MASS IMPORT ANSWER CELLS (#{new_cells_no.num_inserts}): #{e-t}"

    t = Time.now; updated_cells_no = AnswerCell.import([:id, :value, :value_text], update_cells, :on_duplicate_key_update => [:value, :value_text]); e = Time.now
    # puts "MASS IMPORT (update) ANSWER CELLS (#{updated_cells_no.num_inserts}): #{e-t}"
    self.answers.each { |a| a.update_ratings_count }
    return self
  end
  
  # used by draft_data to get positions of values
  def add_value_positions
	  puts "SURVEY_ANSWER.add_value_positions"
    self.answers.map { |answer| answer.add_value_positions }.flatten
      # find question which matches answer
      # puts "answer number & id: #{answer.number} - #{answer.id}"
      # question = self.questions.detect { |question| question.id == answer.question_id }
      # question.merge_answer(answer) if question
    # return self  # return survey with questions with values (answers)
  end
  
  def make_csv_answer
    c = CSVHelper.new
    c.generate_csv_answer_line(c.survey_answer_csv_query)
  end
    
  def create_csv_answer!
    CSVHelper.new.create_survey_answer_csv(self)
  end
  
  def self.create_csv_answers!
    CSVHelper.new.generate_all_csv_answers
  end
  
  

  def to_xml(options = {})
    if options[:builder]
      build_xml(options[:builder])
    else
      xml = Builder::XmlMarkup.new
      xml.__send__(:survey_answer, {:created => self.created_at}) do
        xml.answers do
          # self.rapports.map(&:score_rapports).each do |rapport|
          self.cell_vals.each do |answer_vals|
            xml.__send__(:answer, {:number => answer_vals[:number]}) do
              xml.cells do
                answer_vals[:cells].each do |cell_h|
                  attrs = {:v => cell_h[:v], :var => cell_h[:var], :type => cell_h[:type] }
                  xml.__send__(:cell, attrs)
                end
              end
            end
          end
        end
      end
    end
  end
  
end
