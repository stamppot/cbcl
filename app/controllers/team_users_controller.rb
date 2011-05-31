class TeamUsersController < ApplicationController

  layout false

  def show
    @group = Team.find params[:id]
    @users = @group.users.paginate(:all, :page => params[:page], :per_page => 15) #User.users.in_center(params[:id]).with_groups(params[:id]).in_center(params[:id]).paginate(:all, :page => params[:page], :per_page => 15)
    render :partial => 'shared/users'
  end
end