class ScoreRapport < ActiveRecord::Base
  has_many :score_results, :dependent => :delete_all
  belongs_to :journal_entry
  belongs_to :survey_answer
  belongs_to :survey
  belongs_to :score_scale
  
  named_scope :aged_between, lambda { |start, stop| { :conditions => { :age  => start..stop } } }
  named_scope :from_date, lambda { |start| { :conditions => { :created_at  => start..(Date.now) } } }
  named_scope :to_date, lambda { |stop| { :conditions => { :created_at  => (Date.now)..stop } } }
  named_scope :for_surveys, lambda { |survey_ids| { :conditions => { :survey_id => survey_ids } } } #["survey_answers.survey_id IN (?)", survey_ids] } }


  # # finished survey answers, based on accessible journals
  #   def find_with_options(options = {})  # params are not safe, should only allow page/per_page
  #     page       = options[:page] ||= 1
  #     per_page   = options[:per_page] ||= 100000
  #     o = find_params(options)
  #     params = options[:center] && {:conditions => ['center_id = ?', o[:center].id]} || {}
  #     params[:page] = page
  #     params[:per_page] = per_page
  #     params[:include] = options[:include] if options[:include]
  #     # puts "find_with_options: #{params.inspect}"
  # 
  #     ScoreRapport.for_surveys(o[:surveys]).between(o[:start_date], o[:stop_date]).aged_between(o[:start_age], o[:stop_age]).paginate(params)
  #   end

  def to_csv(csv_survey_answers, survey_id)
    csv_survey_answers.first.variables
    output = FasterCSV.generate(:col_sep => ";", :row_sep => :auto) do |csv_output|
      csv_output << (headers + survey_headers_flat(survey_ids).keys)  # header
      rows.each { |line| csv_output << line.gsub(/^\"|\"$/, "").split(";") }
    end
  end
  
  def self.filter_params(user, options = {})
    options[:start_date]  ||= ScoreRapport.first.created_at
    options[:stop_date]   ||= ScoreRapport.last.created_at
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
  
  def count_with_options(options = {})  # params are not safe, should only allow page/per_page
    o = find_params(options)
    params = options[:center] && {:conditions => ['center_id = ?', o[:center].is_a?(Center) ? o[:center].id : o[:center]]} || {}
    ScoreRapport.for_surveys(o[:surveys]).between(o[:start_date], o[:stop_date]).aged_between(o[:start_age], o[:stop_age]).count(params)
  end

  def find_params(options = {})
    options[:start_date]  ||= ScoreRapport.first.created_at
    options[:stop_date]   ||= ScoreRapport.last.created_at
    options[:start_age]   ||= 0
    options[:stop_age]    ||= 21
    options[:surveys]     ||= Survey.all.map {|s| s.id}
    if !options[:center].blank?
      options[:journal_ids] = options[:center].journal_ids if options[:center] && !options[:journal_ids]
    end
    options[:journal_ids] ||= cache_fetch("journal_ids_user_#{options[:user]}") { self.journal_ids }
    options
  end

  
  def self.count_with_options(user, options = {})  # params are not safe, should only allow page/per_page
    self.with_options(user, options).count #(params)
  end  
  
  # filtrerer ikke på done, også kladder er med
  def self.with_options(user, options)
    o = self.filter_params(user, options)
    query = CsvScoreRapport.for_survey(o[:survey][:id]).
      between(o[:start_date], o[:stop_date]).
      aged_between(o[:start_age], o[:stop_age])
      
    query = query.for_center(options[:center]) if !options[:center].blank?
    query = query.for_team(options[:team]) if !options[:team].blank?
    query
  end

  # def cell_values(prefix = nil)
  #   # prefix ||= self.survey.prefix
  #   a = Dictionary.new
  #   self.score_results.each { |result| a.merge!({ result.score.variable.to_sym => result.result}) }
  #   a.order_by
  # end

  def variable_values
    # variables = self.score_results.map { |sres| [sres.score.variable.to_sym, sres.result] }
    # values = self.cell_values
    # variables.inject(Dictionary.new) do |col,var|
    #   col[var] = values[var] || "#NULL!"
    #   col
    # end
    a = Dictionary.new
    self.score_results.each { |result| a.merge!({ result.score.variable.to_sym => result.result}) }
    a.order_by
  end

  def save_csv_score_rapport
    vals = variable_values
    journal = self.survey_answer.journal
    journal_info = journal.info
    options = {
      :answer => vals.values.join(';;'), 
      :variables => vals.keys.join(';;'),
      :journal_id => self.survey_answer.journal_id,
      :survey_answer_id => self.survey_answer_id,
      :team_id => journal.parent_id,
      :center_id => self.center_id,
      :survey_id => self.survey_id,
      # :journal_entry_id => self.journal_entry_id,
      :age => self.age,
      :created_at => self.created_at,
      :updated_at => self.updated_at,
      # :header => journal_info.keys.join(';'),
      # :journal_info => to_danish(journal_info.values.join(';'))
    }
    info_options = journal.export_info
    options[:sex] = info_options[:pkoen]
    info_options[:journal_id] = options[:journal_id]
    info_options[:team_id] = options[:team_id] unless options[:team_id] == options[:center_id]
    info_options[:center_id] = options[:center_id]
    csv_score_rapport = CsvScoreRapport.find_by_survey_answer_id(options[:survey_answer_id])
    csv_score_rapport ||= CsvScoreRapport.new(options)
    csv_score_rapport.answer = vals.values.join(';;')
    csv_score_rapport.save
  end

  # if scores has been changed, regenerate score_rapport
  def regenerate(force = false)
    # if Score.last_updated > self.updated_at
      survey_answer_id = self.survey_answer_id
      self.score_results.map {|sr| sr.destroy}
      survey_answer = SurveyAnswer.find survey_answer_id
      survey_answer.generate_score_report
      self.updated_at = Time.now
      save
    # end
  end

  def to_xml(options = {})
    if options[:builder]
      build_xml(options[:builder])
    else
      xml = Builder::XmlMarkup.new
      #xml.instruct!
      xml.__send__(:score_rapport, {:survey => self.survey_name, :survey_short => self.short_name, :unanswered => self.unanswered}) do
      # xml.score_rapport do
        # xml.survey self.survey_name
        # xml.survey_short self.short_name
        # xml.unanswered self.unanswered
        self.score_results.each do |result|
          xml.title result.title
          xml.result result.result
          xml.mean result.mean
          xml.percentile98 true if result.percentile_98
          xml.percentile95 true if result.percentile_95
        end
      end
    end
  end
  
end