class MainController < ApplicationController

  layout "survey"

   # TODO: check for logged in user. Else log user out explicitly!
  def index
    redirect_to :controller => :login, :action => :login if current_user.nil?
    flash[:notice] = ""
  end
  
end
