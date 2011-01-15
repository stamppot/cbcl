class JournalStatsController < ApplicationController
	
	def per_page
    REGISTRY[:journals_per_page]
  end
  
	def index
		@journal_stats = JournalStat.surveys_per_center_by_state
		# options = { :include => :parent, :page => params[:page], :per_page => per_page }
  	@answered_by_login_users = JournalEntry.count(:conditions => ['state = ? and answered_at > ?', 6, DateTime.new(2011,01,15)])
		@answered_by_personnel = JournalEntry.count(:conditions => ['state = ? and answered_at > ?', 5, DateTime.new(2011,01,15)])
  	@answered_by_login_users_total = JournalEntry.count(:conditions => ['state = ?', 6])
		@answered_by_personnel_total = JournalEntry.count(:conditions => ['state = ?', 5])
	  # @groups = current_user.journals(options) || [] # TODO: Move to configuration option
	end
	
	def show
		options = { :page => params[:page], :per_page => per_page }
		@center = Center.find(params[:id])
  	@answered_by_login_users = JournalEntry.for_center(params[:id]).answered_by_login_user.count(:conditions => ['answered_at > ?', DateTime.new(2011,01,15)])
		@answered_by_personnel = JournalEntry.for_center(params[:id]).answered.count(:conditions => ['answered_at > ?', DateTime.new(2011,01,15)])
  	@answered_by_login_users_total = JournalEntry.for_center(params[:id]).answered_by_login_user.count
		@answered_by_personnel_total = JournalEntry.for_center(params[:id]).answered.count
		options.merge!(:conditions => ['center_id = ?', params[:id]])
	  @groups = Journal.paginate(options) || [] # TODO: Move to configuration option
	end
	
end