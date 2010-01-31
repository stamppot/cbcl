require File.dirname(__FILE__) + '/../test_helper'
require 'shoulda'

class SurveyAnswerTest < ActiveSupport::TestCase #ActiveSupport::TestCase

  def setup
  end
  
  def teardown
  end

  context "Save survey_answer" do
    context "with perfect parameters" do
      setup do
        @params = {"Q1"=>
          {"q1_2_1"=>"0", "id"=>"1", "q1_3_1"=>"", "q1_4_1"=>"", "q1_5_1"=>""},
           "Q2"=>{"q2_5_1"=>"", "id"=>"2", "q2_2_1"=>"0", "q2_3_1"=>"", "q2_4_1"=>""},
            "Q3"=>{"q3_4_1"=>"", "q3_5_1"=>"", "id"=>"3", "q3_2_1"=>"0", "q3_3_1"=>""},
             "Q4"=>{"q4_2_1"=>"0", "q4_3_1"=>"", "q4_4_1"=>"", "q4_5_1"=>"", "id"=>"4"},
              "Q5"=>{"id"=>"5", "q5_1_2"=>"", "q5_2_2"=>""}, "id"=>"896",
               "Q6"=>{"id"=>"6"},
                "Q10"=>{"q10_94_2"=>"", "q10_95_2"=>"", "q10_110_2"=>"", "q10_31_2"=>"", "q10_102_2"=>"", "q10_87_2"=>"", "q10_76_2"=>"", "q10_123_2"=>"", "q10_66_2"=>"", "q10_42_2"=>"", "q10_11_2"=>"", "q10_89_2"=>"", "id"=>"20", "q10_80_2"=>"", "q10_68_2"=>"", "q10_4_2"=>"", "q10_115_2"=>"", "q10_83_2"=>"", "q10_93_2"=>"", "q10_62_2"=>"", "q10_48_2"=>""}, "Q7"=>{"q7_1_1"=>"0", "q7_1_2"=>"", "id"=>"7", "q7_10_3"=>"", "q7_11_3"=>"", "q7_8_1"=>"", "q7_12_3"=>"", "q7_11_4"=>"", "q7_9_1"=>""}, "Q8"=>{"q8_2_2"=>"", "q8_1_3"=>"", "q8_3_2"=>"", "id"=>"9"}, "controller"=>"survey_answers", "answer"=>{"person"=>"11", "person_other"=>""}}
        @survey_answer = SurveyAnswer.create(:survey => Survey.find(2))
      end
      should "save survey_answers and cells" do
        assert @survey_answer.save_all_answers(@params)
        assert @survey_answer.answers.size == 10
        assert @survey_answer.answers.map {|a| a.answer_cells }.flatten.size > 120
      end
      
      should "create csv_answers" do
        Task.new.create_csv_answer(@survey_answer)
      end
    end
  end
end