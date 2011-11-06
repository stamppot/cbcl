class SurveyPrintsController < ApplicationController
  layout 'survey_print', :only => [:print]

  def print
    @survey = #Rails.cache.fetch("survey_#{params[:id]}") do
      Survey.and_questions.find(Survey.and_questions.find(params[:id]))
    # end
    @page_title = "CBCL - Udskriv Svar: " << @survey.title
  end
  
end
