class CenterJournalsController < ApplicationController

  layout false
  
  def show
    @group = Group.find params[:id]
    @groups = Journal.and_person_info.in_center(@group).paginate(:all, :page => params[:page], :per_page => 15)
  end
end