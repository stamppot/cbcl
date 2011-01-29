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
		puts "START_CONTROLLER #{session[:rbac_user_id]}"
    
		# if request.post?
		puts "FINISH 1 #{params.inspect}  current_user: #{current_user.inspect} session: #{session[:rbac_user_id].inspect}"
		# if session[:rbac_user_id] && (journal_entry = cookies[:journal_entry])  # TODO: put in helper method
		params[:id] ||= cookies[:journal_entry] # login user can access survey with survey_id instead of journal_entry_id
		puts "FINISH 2 #{params.inspect}"
		@journal_entry = JournalEntry.find(params[:id])
		puts "FINISH 3: #{@journal_entry.login_user.inspect}  journal_entry: #{@journal_entry.inspect}"
		# @journal_entry.login_user.destroy if @journal_entry.login_user
		@survey_type = @journal_entry.survey.surveytype
		puts "FINISH 4"
		# if @survey_type == "youth"
		# 	flash[:notice] = "Tak for dit svar!"
		# 	puts "YOUTH FINISH 5"
		# 	cookies.delete :journal_entry
		# 	cookies.delete :user_name
		# 	puts "FINISH 6"
		# 	self.remove_user_from_session!
		# 	puts "FINISH 7"
		# 	redirect_to login_path and return
		# end
		puts "FINISH 8"
		# end
		# cookies.delete :journal_entry
		# cookies.delete :user_name
		puts "FINISH 9"
	end

	def check_logged_in
		true
	end
	
	def check_access
		true
	end
end