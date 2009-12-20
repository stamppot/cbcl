class MainController < ApplicationController

  layout 'cbcl'

   # TODO: check for logged in user. Else log user out explicitly!
  def index
    redirect_to login_path if current_user.nil?
    flash[:notice] = ""
  end
  
end
