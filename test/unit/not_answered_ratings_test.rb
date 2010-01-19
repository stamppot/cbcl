require File.dirname(__FILE__) + '/../test_helper'

# test new code for calculating not_answered_ratings
class NotAnsweredRatingsTest < ActiveSupport::TestCase
  
  def setup
  end
  
  def teardown
  end

  def test_unanswered_ratings_are_equal
    puts "start test"
    surveys = Survey.all
    surveys.each do |survey|
      puts "start test survey #{survey.title} #{survey.id}"
      score = Score.for_survey(survey.id).first
      puts "test score #{score.title} #{score.survey_id}"
      survey_answers = SurveyAnswer.for_survey(survey.id)
      survey_answers.each do |sa| 
        a, b = score.no_unanswered(sa), score.no_unanswered2(sa)
        # puts "#{a==b} a:#{a} b:#{b}" 
      end
    end
    puts "end test"

    surveys = Survey.all
    surveys.each do |survey|
      puts "start test survey #{survey.title} #{survey.id}"
      score = Score.for_survey(survey.id).first
      puts "test score #{score.title} #{score.survey_id}"
      survey_answers = SurveyAnswer.for_survey(survey.id)
      survey_answers.each do |sa| 
        a, b = score.no_unanswered(sa), score.no_unanswered2(sa)
        # puts "#{a==b} a:#{a} b:#{b}"
      end
    end
  end
    
end