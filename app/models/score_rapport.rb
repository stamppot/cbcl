class ScoreRapport < ActiveRecord::Base
  has_many :score_results, :dependent => :delete_all
  belongs_to :journal_entry
  belongs_to :survey_answer
  belongs_to :survey
  belongs_to :score_scale
  
  named_scope :aged_between, lambda { |start, stop| { :conditions => { :age  => start..stop } } }
  named_scope :from_date, lambda { |start| { :conditions => { :created_at  => start..(Date.now) } } }
  named_scope :to_date, lambda { |stop| { :conditions => { :created_at  => (Date.now)..stop } } }
  named_scope :for_surveys, lambda { |survey_ids| { :conditions => { :survey_id => survey_ids } } }

  def self.create_or_update(survey_answer, survey, journal, no_unanswered, created_at, force_update = false)
    args = ScoreRapport.build_params(survey_answer, survey, journal, no_unanswered, created_at)
    rapport = ScoreRapport.find_by_survey_answer_id(survey_answer.id, :include => {:survey_answer => {:journal => :person_info}})            
    rapport = ScoreRapport.create(args) unless rapport
    rapport.update_attributes(args) if force_update && !rapport.new_record?    
    rapport.update_score_results(survey_answer, journal, force_update)
    rapport
  end

  def update_score_results(survey_answer, journal, update = false)
    self.survey.scores.each do |score|
      score_result = ScoreResult.find(:first, :conditions => ['score_id = ? AND score_rapport_id = ?', score.id, self.id])
      
      # everything is calculated already
      if !update && score_result && score_result.dont_update?
        next
      else
        result, percentile, mean, missing, hits, age_group = score.calculate(survey_answer)
        score_ref = score.find_score_ref(journal)
        # ADHD score (id: 57 has no items)
        # puts "update_score_results, survey should be the same: #{survey.id} == #{self.survey_id} #{survey.id == self.survey_id}"
        args = score_result_params(score, result, percentile, mean, hits, missing)
        score_result && score_result.update_attributes(args) || ScoreResult.create(args)
      end
      self.short_name = score.short_name
    end
    save
    self
  end

  def self.build_params(survey_answer, survey, journal, no_unanswered, created_at)
    args = { :survey_name => survey_answer.survey.title,
                  :survey => survey_answer.survey,
              :unanswered => no_unanswered,
              :short_name => survey.category,
                     :age => journal.age,
                  :gender => journal.sex,
               :age_group => survey.age,
              :created_at => created_at,  # set to date of survey_answer
               :center_id => journal.center_id,
        :survey_answer_id => survey_answer.id
            }
  end
  
  def score_result_params(score, result, percentile, mean, hits, missing)
    missing_percentage = 99.99 if score.items_count.blank? or score.items_count == 0
    missing_percentage ||= ((missing.to_f / score.items_count.to_f) * 100.0).round(2)
    args = { 
      :title => score.title, 
      :score_id => score.id, 
      :scale => score.scale, 
      :survey => self.survey,
      :result => result, 
      :percentile_98 => (percentile == :percentile_98),
      :percentile_95 => (percentile == :percentile_95),
      :deviation => (percentile == :deviation),
      :score_rapport => self, 
      :mean => mean,
      :position => score.position,
      :score_scale_id => score.score_scale_id,
      :hits => hits,
      :missing => missing,
      :missing_percentage => missing_percentage, 
      :valid_percentage => (missing_percentage <= 10.0)
    }
  end
  
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
    options[:journal_ids] ||= cache_fetch.fetch("journal_ids_user_#{options[:user]}") { self.journal_ids }
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