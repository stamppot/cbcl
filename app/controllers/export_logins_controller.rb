# encoding: utf-8

require 'fastercsv'

require 'iconv'
# require 'lib/excelinator'
# require 'lib/table_exporter'
# require 'acts_as_xlsx'

class ExportLoginsController < ApplicationController

  # BOM = "\377\376" #Byte Order Mark

  def index

  end

  def show
    @group = Group.find(params[:id])
    @format = [['csv', 'csv'],['xls-utf8', 'utf-8'], ['xls-utf16', 'utf-16le'], ['html excel', 'html']]
  end

  # get login_users in all journals in team
  def download
    team = Group.find(params[:id])
    
    format = params[:format]
    separator = params[:separator]
    filename = team.group_name_abbr + "_logins-" + Time.now.strftime("%Y%m%d%H%M")
  
    rows = CSVHelper.new.get_login_users(team.journals)
    # puts csv.inspect

    # oo = export_xls(team.journals)
    content = ExportCsvHelper.new.to_csv(rows)
    respond_to do |wants|
      # wants.csv { 
      #       send_data oo.to_xlsx.to_stream.read, :filename => "#{filename}.xlsx", :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet"}
      wants.csv { send_data content, :filename => filename + ".csv", :type => "text/csv;charset=utf-8; encoding=utf-8", :disposition => 'attachment' }
      wants.xls { export_csv content, filename + ".xls", format } #export_csv(csv, filename) }  
    end    
  end

  protected

  def export_xls(journals)
    export_data = CSVHelper.new.get_login_users_hash(journals)
    headers = export_data.first
    rows = export_data.second
    export_logins = rows.map {|e| ExportLogin.new(e) }
  end

  def export_csv(table, filename, format = "xls", outputcharset = 'utf-16le', inputcharset = 'utf-8', type = "application/vnd.ms-excel; charset=utf-8")
    bom = "\377\376"
    bom += Iconv.conv('utf-16le', 'utf8', table) 
    puts "BOM: #{bom} #{bom.inspect}"
    puts "csv:\n#{table}"
    extension = format[0..2]
    puts "extension: #{extension}"
    table_exporter = TableExporter.new
    # content = extension == "xls" && table_exporter.to_xls(table) || table_exporter.to_csv(table)
    headers = table.first
    rows = table.second
    content = table_exporter.to_xlsx(headers, rows)
    # content = bom + Iconv.conv(outputcharset, inputcharset, content)
    send_data content, :filename => "#{filename}.#{extension}", :type => type, :content_type => type, :disposition => 'attachment'
  end

  # def export_csv(csv, filename, format = "xls", outputcharset = 'utf-16le', inputcharset = 'utf-8', type = "application/vnd.ms-excel; charset=utf-8")
  #   # content = csv
  #   # bom = "\377\376" #Byte Order Mark
  #   bom = "\377\376"
  #   puts "BOM: #{bom} #{bom.inspect}"
  #   puts "csv:\n#{csv}"
  #   extension = format[0..2]
  #   content = extension == "xls" && Excelinator.csv_to_xls(csv) || csv
  #   content = bom + Iconv.conv(outputcharset, inputcharset, content)
  #   send_data content, :filename => "#{filename}.#{extension}", :type => type, :content_type => type, :disposition => 'attachment'
  # end
end

