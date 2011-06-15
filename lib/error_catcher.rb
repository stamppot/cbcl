class ActionController::Base

  def rescue_action_in_public(exception)
    #maybe gather up some data you'd want to put in your error page
  
    case exception
      when ActiveRecord::RecordNotFound
        puts "ERROR CATCHER!!!!!!"
        @message = "record not found..."
        render :template => "main/error404", :layout => false, :status => "404"
      when ActiveRecord::RecordInvalid
      when ActionController::RoutingError
      when ActionController::UnknownController
      when ActionController::UnknownAction
      when ActionController::MethodNotAllowed
        render :template => "main/error404", :layout => false, :status => "404"
      else
        render :template => "main/error", :layout => false, :status => "500"
    end             
  end

end