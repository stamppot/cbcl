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


  # finished survey answers, based on accessible journals
  def find_with_options(options = {})  # params are not safe, should only allow page/per_page
    page       = options[:page] ||= 1
    per_page   = options[:per_page] ||= 100000
    o = find_params(options)
    params = options[:center] && {:conditions => ['center_id = ?', o[:center].id]} || {}
    params[:page] = page
    params[:per_page] = per_page
    params[:include] = options[:include] if options[:include]
    puts "find_with_options: #{params.inspect}"
    ScoreRapport.for_surveys(o[:surveys]).between(o[:start_date], o[:stop_date]).aged_between(o[:start_age], o[:stop_age]).paginate(params)
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
    options[:journal_ids] ||= Rails.cache.fetch("journal_ids_user_#{options[:user]}") { self.journal_ids }
    options
  end

  # if scores has been changed, regenerate score_rapport
  def regenerate(force = false)
    # if Score.last_updated > self.updated_at
      survey_answer_id = self.survey_answer_id
      self.score_results.map {|sr| sr.destroy}
      survey_answer = SurveyAnswer.find survey_answer_id
      survey_answer.generate_score_rapport
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