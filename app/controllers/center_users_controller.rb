class CenterUsersController < ApplicationController

  layout false
  
  def show
    @users = User.users.in_center(params[:id]).paginate(:all, :page => params[:page], :per_page => 15)
  end
end