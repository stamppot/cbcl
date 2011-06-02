require 'fastercsv'

class ExportLoginsController < ApplicationController

  # get login_users in all journals in team
  def download
    group = Group.find(params[:id])
    
    options = {
      :filename => Time.now.strftime("%Y%m%d%H%M%S") + "_login_brugere_#{group.is_a?(Team) && 'team' || 'center'}_#{group.title.underscore}.csv",
      :type => 'text/csv',
      :disposition => 'attachment'
      }          
      csv = CSVHelper.new.login_users(group.journals)

    respond_to do |wants|
      wants.html { send_data(csv, options) }
      wants.csv  { send_data(csv, options) }
    end    
  end
end

