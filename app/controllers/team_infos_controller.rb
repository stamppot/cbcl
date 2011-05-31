class TeamInfosController < ApplicationController

  layout false
  
  def show
    @group = Team.find params[:id]
    @journal_count = Journal.for_parent(@group).count
    @user_count = @group.users.count
    
    render :partial => 'teams/info'
  end
end

