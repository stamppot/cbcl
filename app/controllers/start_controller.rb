class StartController < ApplicationController
	# helper SurveyHelper

	def start
		@page_title = "CBCL Spørgeskemaer" 
		@journal_entry = JournalEntry.find_by_user_id(current_user.id)
		redirect_to login_path and return if @journal_entry.nil?
		@survey = Rails.cache.fetch("survey_#{@journal_entry.survey_id}") do
      Survey.and_questions.find(@survey_answer.survey_id)
    end
    respond_to do |format|
      format.html 
      format.html { redirect_to survey_start_path and return}
    end
	end

	def edit
		@page_title = "CBCL Spørgeskemaer" 
		@journal_entry = JournalEntry.find_by_user_id(current_user.id)
		redirect_to login_path and return if @journal_entry.nil?
		@survey = @journal_entry.survey
	end

	def finish
		@journal_entry = JournalEntry.find_by_user_id(current_user.id)
    # @survey_type = @journal_entry.survey.surveytype
		cookies.delete "journal_entry"
	end

	def check_logged_in
		true
	end
	
	def check_access
		true
	end
end