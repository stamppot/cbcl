class CenterTeamsController < ApplicationController

  layout false
  
  def show
    @group = Center.find params[:id]
    @teams = Team.in_center(@group)
    @hide_team = true
  end
end