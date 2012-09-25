require 'fastercsv'

class CsvSurveyAnswer < ActiveRecord::Base
  belongs_to :survey_answer
  belongs_to :survey
  belongs_to :journal_entry
  belongs_to :journal
  belongs_to :center
  belongs_to :team
  
  validates_uniqueness_of :survey_answer_id
  
  named_scope :by_survey_answer, lambda { |id| { :conditions => ['survey_answer_id = ?', id], :limit => 1 } }
  named_scope :by_journal_and_survey, lambda { |j_id, survey_id| { :conditions => ['journal_id = ? and survey_id = ?', j_id, survey_id], :limit => survey_ids.size, :order => 'survey_id' } }
  named_scope :by_survey_answer_and_surveys, lambda { |sa_id, survey_ids| { :conditions => ['survey_answer_id = ? and survey_id IN (?)', sa_id, survey_ids], :limit => survey_ids.size, :order => 'survey_id' } }  

  named_scope :between, lambda { |start, stop| { :conditions => { :created_at  => start..stop } } }
  named_scope :aged_between, lambda { |start, stop| { :conditions => { :age  => start..stop } } }
  named_scope :from_date, lambda { |start| { :conditions => { :created_at  => start..(Date.now) } } }
  named_scope :to_date, lambda { |stop| { :conditions => { :created_at  => (Date.now)..stop } } }
  # named_scope :for_survey, lambda { |survey_id| { :conditions => { :survey_id => survey_id } } }
  named_scope :for_survey, lambda { |survey_id| { :conditions => ["csv_survey_answers.survey_id = ?", survey_id] } }
  named_scope :for_center, lambda { |center_id| { :conditions => ["csv_survey_answers.center_id = ?", center_id] } }
  named_scope :for_team, lambda { |team_id| { :conditions => ["csv_survey_answers.team_id = ?", team_id] } }


  def to_csv(csv_survey_answers, survey_id)
    csv_survey_answers.first.variables
    output = FasterCSV.generate(:col_sep => ";", :row_sep => :auto) do |csv_output|
      csv_output << (headers + survey_headers_flat(survey_ids).keys)  # header
      rows.each { |line| csv_output << line.gsub(/^\"|\"$/, "").split(";") }
    end
  end
  
  def self.filter_params(user, options = {})
    options[:start_date]  ||= SurveyAnswer.first.created_at
    options[:stop_date]   ||= SurveyAnswer.last.created_at
    options[:start_age]   ||= 0
    options[:stop_age]    ||= 21

    options[:center] = user.center if !user.access?(:superadmin)
    if !options[:center].blank?
      center = Center.find(options[:center])
      options[:conditions] = ['center_id = ?', options[:center]]
      options[:journal_ids] = center.journal_ids if center && !options[:journal_ids]
    end
    options[:journal_ids] ||= cache_fetch("journal_ids_user_#{self.id}") { user.journal_ids }
    # puts "survey_answer_params: #{options.inspect}"
    options
  end
  
  def self.count_with_options(user, options = {})  # params are not safe, should only allow page/per_page
    self.with_options(user, options).count #(params)
  end  
  
  # filtrerer ikke på done, også kladder er med
  def self.with_options(user, options)
    o = self.filter_params(user, options)
    query = CsvSurveyAnswer.for_survey(o[:survey][:id]).
      between(o[:start_date], o[:stop_date]).
      aged_between(o[:start_age], o[:stop_age])
      
    query = query.for_center(options[:center]) if !options[:center].blank?
    query = query.for_team(options[:team]) if !options[:team].blank?
    query
  end
  
  # def self.with_options(options)
  def headers
    %w{ssghafd ssghnavn safdnavn pid alt_id pkoen palder pnation dagsdato pfoedt}.join(';;')
  end

end