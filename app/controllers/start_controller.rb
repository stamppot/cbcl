class StartController < ApplicationController
	# helper SurveyHelper

	def start
		@page_title = "CBCL Spørgeskemaer" 
		@journal_entry = JournalEntry.find_by_user_id(current_user.id)
		redirect_to login_path and return if @journal_entry.nil?
		@survey = @journal_entry.survey
		# render :edit if @journal_entry.survey_answer
	end

	def edit
		@page_title = "CBCL Spørgeskemaer" 
		@journal_entry = JournalEntry.find_by_user_id(current_user.id)
		redirect_to login_path and return if @journal_entry.nil?
		@survey = @journal_entry.survey
	end

	# def finish
	#   login_user = LoginUser.find_by_id(params[:id])
	#   # login_user.destroy if login_user
	#   remove_current_user
	# end

	def finish
		# if session[:rbac_user_id] && (journal_entry = cookies[:journal_entry])  # TODO: put in helper method
		# params[:id] ||= cookies[:journal_entry] # login user can access survey with survey_id instead of journal_entry_id
		puts "FINISH 2 #{params.inspect}"
		@journal_entry = JournalEntry.find(params[:id])
		puts "FINISH 3: #{@journal_entry.login_user.inspect}  journal_entry: #{@journal_entry.inspect}"
		# @journal_entry.login_user.destroy if @journal_entry.login_user
		@survey_type = @journal_entry.survey.surveytype
		cookies.delete "journal_entry"
		puts "FINISH 4"
	end

	def check_logged_in
		true
	end
	
	def check_access
		true
	end
end