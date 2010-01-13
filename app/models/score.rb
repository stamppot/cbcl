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
  
  def no_unanswered(survey_answer)
    score_item = self.score_items.first
    # find answer to count values in
    answer = survey_answer.answers.detect {|answer| answer.number == score_item.question.number }
    return answer.ratings_count if answer # 11-01-10 was answer.not_answered_ratings
    # c2 = Query.new.not_answered(answer.id)
    # puts "#{c==c2} number: #{answer.id} a #{c}, b #{c2}"
    # puts "#{c-c2} #{c == c2}: #{c} == #{c2}"
    return 0
  end

  # def no_unanswered2(survey_answer)
  #   score_item = self.score_items.first
  #   # find answer to count values in
  #   # answer = survey_answer.answers.detect {|answer| answer.question_id == score_item.question_id }
  #   answer = survey_answer.answers.detect {|answer| answer.number == score_item.question.number }
  #   if answer
  #     c = Query.new.not_answered(answer.id)
  #     # puts "answer.number: #{answer.number}  notanswered #{c}"
  #     return c
  #   end
  #   return 0
  # end
  
  # delegates calculation to the right score_item
  def calculate(survey_answer, journal)
    s_type = survey_answer.surveytype
    
    # find matching type in score_items, so only the score item for the type of survey is calculated
    score_item = self.score_items.first
    score_ref  = self.find_score_ref(journal)

    row_result = []
    if score_item.nil?
      row_result << 0 # "empty"
    else
      row_result << score_item.calculate(survey_answer) # other survey scores are added as columns
    end

    if score_ref
      res = row_result.first.to_i
      
      percentile = if (res && score_ref && score_ref.percent98) && res >= score_ref.percent98
        "(#{score_ref.mean.to_danish}) **"
      elsif (res && score_ref && score_ref.percent95) && res >= score_ref.percent95
        "(#{score_ref.mean.to_danish}) *&nbsp;"
      else
        score_ref.mean.to_s.empty? && "" ||
        "(#{score_ref.mean.to_s.gsub('.', ',')}) &nbsp;&nbsp;&nbsp;"  # should all norm values
      end
      return [res, percentile]
    else
      return row_result
    end
  end
  
  def score_report(survey_answer, journal)
    report = ScoreReport.new
    report.title = self.title
    report.score = self
    report.scale = self.score_scale.position - 1 # used to generate ids to hide score group
    report.short_name = self.short_name
    results = self.calculate(survey_answer, journal)
    report.result = results[0]
    report.percentile = results[1]
    return report
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
