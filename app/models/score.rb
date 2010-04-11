class Score < ActiveRecord::Base
  has_many :score_items, :dependent => :delete_all
  has_many :score_refs, :dependent => :delete_all

  belongs_to :survey
  belongs_to :score_scale

  named_scope :for_survey, lambda { |survey_id| { :conditions => ["scores.survey_id = ?", survey_id] } }
  named_scope :with_survey_and_scale, :include => [:survey, :score_scale]
  acts_as_list :scope => :score_group
  
  validates_presence_of :title, :message => ': navn skal gives'
  validates_presence_of :survey, :message => ': et skema skal vælges'
  
  attr_accessor :action # attribute not saved in db, to help with ajax

  
  # creates score items for selected surveys when a score is created
  def create_score_items(surveys)
    surveys.each do |survey|
      item = ScoreItem.new
      item.survey_id = survey
      self.score_items << item
    end
    self.save
  end
  
  # returns score ref with the right age_group and gender
  def find_score_ref(journal)
    score_ref = self.score_refs.detect do |score_ref|
      score_ref.age_range === journal.age && score_ref.gender == journal.sex
    end
    return false if score_ref.nil?
    return score_ref
  end
  
  # delegates calculation to the right score_item
  def calculate(survey_answer)
    s_type = survey_answer.surveytype
    
    # find matching type in score_items, so only the score item for the type of survey is calculated
    score_item = self.score_items.first
    score_ref  = self.find_score_ref(survey_answer.journal)
    
    mean = score_ref && score_ref.mean || 0.0
    missing = 0
    result = 0
    result, missing = score_item.calculate(survey_answer) if score_item
    row_result = [result]  # other survey scores are added as columns
    return row_result << :normal << mean << missing << 
      (survey_answer.survey.age) unless score_ref  # guard clause when no score_ref exists
      
    # res = row_result.first.to_i
    percentile = if (result && score_ref && score_ref.percent98) && result >= score_ref.percent98
      :percentile_98
    elsif (result && score_ref && score_ref.percent95) && result >= score_ref.percent95
      :percentile_95
    elsif score_ref.mean > 0.0
      :deviation
    else
      :normal
    end
    return [result, percentile, mean, missing, survey_answer.survey.age] # TODO: make some collection object (struct)
  end

  def result(survey_answer, journal)
    self.calculate(survey_answer, journal).first
  end
  
  def percentile(survey_answer, journal)
    self.calculate(survey_answer, journal)[1]
  end
  
  def sum_type
    sum_types.invert[self.sum]
  end
  
  def scale_text
    self.score_scale.title
  end

  def sum_types
    Score.default_sum_types
  end
    
  def scales
    ScoreScale.all.map { |scale| [scale.title, scale.id] }
  end

  def item_qualifiers
    Score.default_qualifiers
  end

  def <=>(other)
    if self.short_name == other.short_name
      self.scale <=> other.scale
    else
      self.short_name <=> other.short_name
    end
  end

  def to_s
    "<br>Score: #{id}" + "<br>" + title + "<br>" + "Skema: #{short_name}" + "<br>" + "Tælling: #{sum_type}" + "<br>" + "Skala: #{scale}" + "<br>"
  end
  
  def score_headers(survey)
    Score.for_survey(survey.id).map {|s| s.title }
  end
  
  # used to generate score_result
  def Score.percentile_string(percentile, mean)
    case percentile
    when :percentile_98: "(#{mean.to_danish}) **"  
    when :percentile_95: "(#{mean.to_danish}) *&nbsp;"
    when :deviation: "(#{mean.to_danish}) &nbsp;&nbsp;&nbsp;"
    when :normal: ""
    else ""
    end
  end
  
  private

  def Score.default_sum_types
    {
      'normal' => 1,
      'dicotomi' => 2
    }
  end

  def Score.default_qualifiers
    {
      'valgte' => 0,
      'alle'   => 1,
      'undtaget' => 2
    }
  end

  
end
