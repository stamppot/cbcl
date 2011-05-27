# class AddIndexSurveyAnswers < ActiveRecord::Migration
#   def self.up
#     add_index :survey_answers, :center_id
#     add_index :survey_answers, :age
#     add_index :survey_answers, :done
#   end
# 
#   def self.down
#     remove_index :survey_answers, :done
#     remove_index :survey_answers, :age
#     remove_index :survey_answers, :center_id
#   end
# end