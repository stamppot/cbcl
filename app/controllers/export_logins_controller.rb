require 'fastercsv'

require 'iconv'
require 'lib/excelinator'

class ExportLoginsController < ApplicationController

  # BOM = "\377\376" #Byte Order Mark
  
  # get login_users in all journals in team
  def download
    team = Group.find(params[:id])
    csv = CSVHelper.new.login_users(team.journals)

    filename = team.title.underscore + "_logins-" + Time.now.strftime("%Y%m%d%H%M") + ".xls"
  
    respond_to do |wants|
      wants.csv { export_csv csv, filename } #export_csv(csv, filename) }
      wants.xls { export_csv csv, filename } #export_csv(csv, filename) }  
    end    
  end

  protected

  def export_csv(csv, filename, type = "application/vnd.ms-excel; charset=utf-8")
    # content = csv
    # bom = "\377\376" #Byte Order Mark
    # puts "BOM: #{bom} #{bom.inspect}"
    # puts "csv:\n#{csv}"
    # content = bom + csv # Iconv.conv("utf-16le", "utf-8", csv)
    content = Excelinator.csv_to_xls(csv)
    send_data content, :filename => filename, :type => type, :content_type => type, :disposition => 'attachment'
  end
end

