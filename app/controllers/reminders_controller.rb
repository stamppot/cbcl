# encoding: utf-8

class RemindersController < ApplicationController 
  
  def show
    @group = Group.find params[:id]
    # @state = params[:state] || 2
    # @start_date = @group.created_at
    # @stop_date = DateTime.now
    # @journal_entries = JournalEntry.for_parent_with_state(@group, @state).between(@start_date, @stop_date).
    #   paginate(:all, :page => params[:page], :per_page => 40, :order => 'created_at desc')
    # @stop_date = @journal_entries.any? && @journal_entries.last.created_at || DateTime.now
    # puts "#{params[:state]}"
    set_params_and_find(params)
    
    @surveys = Survey.all.to_hash(&:id).invert
    @states = {'Alle' => 0, 'Ubesvaret' => 2, 'Besvaret' => "5,6", 'Kladde' => 4} #JournalEntry.states
    respond_to do |format|
      format.html
      format.js {
        render :update do |page|
          page.replace_html 'journal_entries', :partial => 'shared/select_entries'
          page.visual_effect :highlight, 'journal_entries'
        end
      }
    end
  end
  
  def generate_file
    @group = Group.find(params[:id])
    selected_state = params[:state]
    selected_state = [2,3,4,5,6] if selected_state == "0"

    @state = selected_state.to_a
    @start_date = @group.created_at
    @stop_date = DateTime.now

    status = @state.join("")
    timestamp = Time.now.strftime('%Y%m%d')
    filename = "journalstatus_#{@group.group_name_abbr.underscore}-#{status}-#{timestamp}.xls" 

    export_file = if !File.exists? "files/#{filename}"
      @journal_entries = JournalEntry.for_parent_with_state(@group, @state).
        between(@start_date, @stop_date).all(:order => 'created_at desc') unless @state.empty?
      export_csv_helper = ExportCsvHelper.new
      rows = export_csv_helper.get_entries_status(@journal_entries)
      ExportFile.export_xls_file rows, filename, "application/vnd.ms-excel"
    else
      ExportFile.find_by_filename filename
    end

    export_file = ExportFile.last
    respond_to do |wants|
      wants.js {
        render :update do |page|
          page.insert_html :after, 'export_file', link_button("Hent fil", file_download_path(export_file.id), 
            :class => 'button download_file')
          page.visual_effect :highlight, 'export_file'
        end
      }
    end    
  end

  # old, download csv
  def download
    @group = Group.find(params[:id])
    selected_state = params[:selected_state]
    selected_state = [2,3,4,5,6] if selected_state == "0"

    @state = selected_state.to_a
    @start_date = @group.created_at
    @stop_date = DateTime.now

    @journal_entries = JournalEntry.for_parent_with_state(@group, @state).
      between(@start_date, @stop_date).all(:order => 'created_at desc') unless @state.empty?
    # puts "" << @journal_entries[0..4].map(&:status).inspect
    export_csv_helper = ExportCsvHelper.new
    rows = export_csv_helper.get_entries_status(@journal_entries)
    csv = export_csv_helper.to_csv(rows)
    respond_to do |wants|
      timestamp = Time.now.strftime('%Y%m%d%H%M')
      filename = "journalstatus_#{@group.group_name_abbr.underscore}-#{timestamp}.csv" 
      wants.html {
        export_csv(csv, filename, 'text/csv;charset=utf-8; encoding=utf-8')
      }
      wants.csv {
        export_csv(csv, filename, 'text/csv;charset=utf-8; encoding=utf-8')
      }
    end    
  end

  protected 
  
  def export_csv(csv, filename, type = "application/vnd.ms-excel; charset=utf-8")
    bom = "\377\376"
    content = csv # Iconv.conv('utf-16le', 'utf8', csv)
    send_data content, :filename => filename, :type => type, :disposition => 'attachment'
  end

  def set_params_and_find(params)
    # puts "#{params[:state].inspect}"
    params[:state] ||= "2\/4"
    states = params[:state].split("\/")
    # puts "states: #{states.inspect}"
    params[:state] = states.map &:to_i
    # puts "#{params[:state].inspect}"
    params[:state] = params[:journal_entry][:state] if params[:journal_entry] && params[:journal_entry][:state] 
    puts "selected_state: #{params[:selected_state].inspect}"
    @state = params[:selected_state] if params[:selected_state]
    @state = states # params[:state].to_s.split(',') unless params[:state].blank?
    @state = [] if @state.nil?    [2,3] if @state.nil?
    @answer_state = @state.join(",")
    @state = JournalEntry.states.values if params[:state] == "0"
    @start_date = @group.created_at
    @stop_date = DateTime.now
    @journal_entries_count = JournalEntry.for_parent_with_state(@group, @state).
      between(@start_date, @stop_date).count
    @journal_entries = JournalEntry.for_parent_with_state(@group, @state).
      between(@start_date, @stop_date).all(:order => 'created_at desc', :include => :journal) unless @state.empty?
    @stop_date = @journal_entries.any? && @journal_entries.last.created_at || DateTime.now
  end
end