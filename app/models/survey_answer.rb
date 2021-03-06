# encoding: utf-8

require 'ar-extensions/adapters/mysql'
require 'ar-extensions/import/mysql'
# require 'facets'

class SurveyAnswer < ActiveRecord::Base
  belongs_to :survey
  belongs_to :journal
  belongs_to :center
  belongs_to :team
  has_many :answers, :dependent => :destroy, :include => [ :answer_cells ], :order => :number
  #belongs_to :journal_entry
  has_one :journal_entry
  has_one :score_rapport, :dependent => :destroy, :include => [ :score_results ]
  has_one :csv_survey_answer, :dependent => :destroy
  has_one :csv_score_rapport, :dependent => :destroy
  
  named_scope :finished, :conditions => ['done = ?', true]
  named_scope :for_center, lambda { |center_id| { :conditions => ['center_id = ?', center_id] } }

  named_scope :order_by, lambda { |column| { :order => column } }
  named_scope :and_answer_cells, :include => { :answers => :answer_cells }
  named_scope :and_questions, :include => { :survey => :questions }
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

  def age_when_answered
     ( (self.created_at.to_datetime - self.journal.birthdate).to_i / 365.25).floor
  end
   
  def age_now
    ( (DateTime.now - self.journal.birthdate).to_i / 365.25).floor
  end
  
  def update_age!
    age = age_when_answered
    csv_survey_answer.age = age
    csv_score_rapport.age = age
    self.save
    csv_survey_answer.save
    csv_score_rapport.save
  end


  def save_draft(params)
    survey_answer = journal_entry.survey_answer
    survey_answer.done = false
    survey_answer.journal_entry_id ||= journal_entry.id
    survey_answer.set_answered_by(params)
    survey_answer.save_answers(params)
    survey_answer.center_id ||= journal_entry.journal.center_id
    survey_answer.save
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
      score_rapport = self.generate_score_report(update = true) # generate score report
      self.save_csv_survey_answer
      score_rapport.save_csv_score_rapport
      # self.create_csv_answer!
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
	
	# def get_variables # do not cache, coz the cells are merged with answer cells
 #    d = Dictionary.new
 #    self.answers.each { |answer| d = d.merge!(answer.get_variables(survey.prefix)) }
 #    d.order_by
 #  end
  
  # def to_csv
  #   self.survey.cell_variables.merge!(self.cell_values(self.survey.prefix)).values
  # end

  def cell_values(prefix = nil)
    prefix ||= self.survey.prefix
    a = Dictionary.new
    self.answers.each { |answer| a.merge!(answer.cell_values(prefix)) }
    a.order_by
  end
  
    # info on journal in array of hashes
  def info
    j = self.journal
    # settings = CenterSetting.find_by_center_id_and_name(self.center_id, "use_as_code_column")
    c = Dictionary.new # ActiveSupport::OrderedHash.new
    c["ssghafd"] = j.group.group_code
    c["ssghnavn"] = self.center.title
    c["safdnavn"] = j.group.title
    c["pid"] = j.code #settings && eval("self.#{settings.value}") || j.code
    c["projekt"] = j.alt_id || ""
    c["pkoen"] = j.sex
    c["palder"] = self.age_when_answered  # alder på besvarelsesdatoen
    c["pnation"] = j.nationality
    c["besvarelsesdato"] = self.created_at.strftime("%d-%m-%Y")
    c["pfoedt"] = j.birthdate.strftime("%d-%m-%Y")  # TODO: translate month to danish
    c
  end

  # def cell_vals(prefix = nil)
  #   prefix ||= self.survey.prefix
  #   a = []
  #   self.answers.each { |answer| a << (answer.cell_vals(prefix)) }
  #   a
  #   # a.order_by
  # end
  
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
  
  def add_missing_cells
    self.max_answer.add_missing_cells
  end
  
  def sex_text
    PersonInfo.sexes.invert[self[:sex]]
  end
  
  # get all scores related to this survey answer.
  def scores
    Survey.find(survey_id, :include => { :scores => :score_items } ).scores
  end

  def update_score_report(update = false)
    rapport = ScoreRapport.find_by_survey_answer_id(self.id, :include => {:survey_answer => :journal})
    args = { :survey_name => self.survey.get_title,
                  :survey => self.survey,
              :unanswered => self.no_unanswered,
              :short_name => self.survey.category,
                     :age => self.age_when_answered,
                  :gender => self.journal.sex,
               :age_group => self.survey.age,
              :created_at => self.created_at,  # set to date of survey_answer
               :center_id => self.center_id,
        :survey_answer_id => self.id
            }
    rapport.update_attributes(args) if update && !rapport.new_record?
  end

  def generate_score_report(update = false)
    rapport = ScoreRapport.find_by_survey_answer_id(self.id, :include => {:survey_answer => :journal})
    args = { :survey_name => self.survey.get_title,
                  :survey => self.survey,
              :unanswered => self.no_unanswered,
              :short_name => self.survey.category,
                     :age => self.age_when_answered,
                  :gender => self.journal.sex,
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
    rapport.save_csv_score_rapport
    rapport
  end
        
  # print all values iteratively
  def print
    output = "Survey Answer: #{self.survey.get_title}<br>"
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
      q_number = q_number.to_i
      # puts "q_id: #{q_id}, q_no: #{q_number}"

      an_answer = self.answers.find_by_question_id(q_id)
      an_answer ||= self.answers.create(:survey_answer_id => self.id, :question_id => q_id, :number => q_number)
      new_cells ||= {}
      q_cells.each do |cell, value|
        if cell =~ /q(\d+)_(\d+)_(\d+)/   # match col, row
          q = "Q#{$1}"
          a_cell = {:answer_id => an_answer.id, :row => $2.to_i, :col => $3.to_i, :value => value, :number => q_number}
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
  def setup_draft_values
    self.answers.map { |answer| answer.setup_draft_values }.flatten
  end
  
  def variable_values
    variables = self.survey.variables.map {|v| v.var.to_sym}
    values = self.cell_values
    variables.inject(Dictionary.new) do |col,var|
      col[var] = values[var] || "#NULL!"
      col
    end
    #variables
  end
  
  def save_csv_survey_answer
    vals = variable_values
    options = {
      :answer => vals.values.join(';;'), 
      :journal_id => self.journal_id,
      :survey_answer_id => self.id,
      :center_id => self.center_id,
      :team_id => self.team_id,
      :survey_id => self.survey_id,
      :journal_entry_id => self.journal_entry_id,
      :age => self.age_when_answered,
      :sex => self.journal.sex,
      :created_at => self.created_at,
      :updated_at => self.updated_at,
      :journal_info => to_danish(self.info.values.join(';;'))
    }
    
    csa = self.csv_survey_answer
    if csa
      csa.update_attributes(options)
    else
      csa = CsvSurveyAnswer.create(options)
    end
  end
  
  def to_danish(str)
    str.gsub("Ã¸", "ø").gsub("Ã¦", "æ").gsub("Ã…", "Å")
  end
    
  def self.create_csv_answers!
    CSVHelper.new.generate_all_csv_answers
  end
  
  # finished survey answers, based on accessible journals
  def self.filter_finished(user, options = {})  # params are not safe, should only allow page/per_page
    page       = options[:page] ||= 1
    per_page   = options[:per_page] ||= 100000
    o = self.filter_params(user, options)
    params = options[:center] && {:conditions => ['center_id = ?', o[:center].id]} || {}
    SurveyAnswer.for_surveys(o[:surveys]).finished.between(o[:start_date], o[:stop_date]).aged_between(o[:start_age], o[:stop_age]).paginate(params.merge(:page => page, :per_page => per_page))
  end

  def self.filter_finished_count(user, options = {})  # params are not safe, should only allow page/per_page
    o = self.filter_params(user, options)
    params = options[:center] && {:conditions => ['center_id = ?', o[:center].is_a?(Center) ? o[:center].id : o[:center]]} || {}
    SurveyAnswer.for_surveys(o[:surveys]).finished.between(o[:start_date], o[:stop_date]).aged_between(o[:start_age], o[:stop_age]).count(params)
  end

  def self.filter_params(user, options = {})
    options[:start_date]  ||= SurveyAnswer.first.created_at
    options[:stop_date]   ||= SurveyAnswer.last.created_at
    options[:start_age]   ||= 0
    options[:stop_age]    ||= 28
    # options[:surveys]     ||= Survey.all.map {|s| s.id}
    if !options[:center].blank?
      center = Center.find(options[:center])
      options[:journal_ids] = center.journal_ids if center && !options[:journal_ids]
    end
    options[:journal_ids] ||= user.journal_ids
    options
  end

  # def to_xml(options = {})
  #   if options[:builder]
  #     build_xml(options[:builder])
  #   else
  #     xml = Builder::XmlMarkup.new
  #     xml.__send__(:survey_answer, {:created => self.created_at}) do
  #       xml.answers do
  #         # self.rapports.map(&:score_rapports).each do |rapport|
  #         self.cell_vals.each do |answer_vals|
  #           xml.__send__(:answer, {:number => answer_vals[:number]}) do
  #             xml.cells do
  #               answer_vals[:cells].each do |cell_h|
  #                 attrs = {:v => cell_h[:v], :var => cell_h[:var], :type => cell_h[:type] }
  #                 xml.__send__(:cell, attrs)
  #               end
  #             end
  #           end
  #         end
  #       end
  #     end
  #   end
  # end
  
end
