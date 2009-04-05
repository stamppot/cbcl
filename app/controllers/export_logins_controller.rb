require 'fastercsv'

class ExportLoginsController < ApplicationController

  # get login_users in all journals in team
  def download
    team = Team.find(params[:id])
    
    respond_to do |wants|
      wants.html {
        @login_users = team.journals.map { |journal| journal.journal_entries }.flatten.map {|entry| entry.login_user}.compact
      }
      wants.csv {
        csv = CSVHelper.new.login_users(team.journals)
        
        send_data(csv, :filename => Time.now.strftime("%Y%m%d%H%M%S") + "_login_brugere_team_#{team.title.underscore}.csv", 
                  :type => 'text/csv', :disposition => 'attachment')
      }
    end    
  end
end
