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
  
  def download
    @group = Group.find(params[:id])
    set_params_and_find(params)
    csv = CSVHelper.new.entries_status(@journal_entries)
    
    respond_to do |wants|
      wants.html {
        send_data(csv, :filename => Time.now.strftime("%Y-%m-%d") + "_journalstatus_#{@group.title.underscore}.csv", 
                  :type => 'text/csv', :disposition => 'attachment')
      }
      wants.csv {
        send_data(csv, :filename => Time.now.strftime("%Y-%m-%d") + "_journalstatus_#{@group.title.underscore}.csv", 
                  :type => 'text/csv', :disposition => 'attachment')
      }
    end    
  end

  protected 
  
  def set_params_and_find(params)
    # puts "#{params[:state].inspect}"
    params[:state] ||= "1\/2\/3\/4\/5\/6"
    states = params[:state].split("\/")
    # puts "states: #{states.inspect}"
    params[:state] = states.map &:to_i
    # puts "#{params[:state].inspect}"
    params[:state] = params[:journal_entry][:state] if params[:journal_entry] && params[:journal_entry][:state] 
    @state = states # params[:state].to_s.split(',') unless params[:state].blank?
    @state = [2,3] if @state.nil?
    @state = JournalEntry.states.values if params[:state] == "0"
    @start_date = @group.created_at
    @stop_date = DateTime.now
    @journal_entries = JournalEntry.for_parent_with_state(@group, @state).
      between(@start_date, @stop_date).all(:order => 'created_at desc')
    @stop_date = @journal_entries.any? && @journal_entries.last.created_at || DateTime.now
  end
end