class RemindersController < ApplicationController 
  
  
  def show
    @group = Group.find params[:id]
    puts "PARAMS: #{params.inspect}  #{params["state"]}"
    @state = params[:state] || 2
    @start_date = @group.created_at
    @stop_date = DateTime.now
    # params[:start_date] ||= @start_date
    # params[:stop_date] ||= @stop_date
    # puts "time: #{@start_date}, #{@stop_date}"
    # params = Query.filter_date(@start_date, @stop_date)
    @journal_entries = JournalEntry.for_parent_with_state(@group, @state).between(@start_date, @stop_date).
      paginate(:all, :page => params[:page], :per_page => 40, :order => 'created_at desc')

    @stop_date = @journal_entries.any? && @journal_entries.last.created_at || DateTime.now
    
    @states = JournalEntry.states
    respond_to do |format|
      format.html
      format.js {
        render :update do |page|
          page.replace_html 'journal_entries', :partial => 'shared/select_entries'
        end
      }
    end
    
  end
  
end