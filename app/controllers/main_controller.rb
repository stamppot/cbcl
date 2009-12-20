class MainController < ApplicationController
  layout 'cbcl'

  def index
    redirect_to login_path if current_user.nil?
  end
  
  def check_access
    if current_user.nil?
      remove_current_user
      redirect_to login_path and return 
    else
      return true
    end
  end
end
