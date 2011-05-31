class TeamJournalsController < ApplicationController

  layout false
  
  def show
    @group = Team.find(params[:id])
    @groups = Journal.for_parent(@group).by_code.and_person_info.paginate(:all, :page => params[:page], :per_page => journals_per_page) || []
    render :partial => 'shared/journals'
  end
end