module ActiveRbacMixins
  # Mix this module into your ApplicationController to get the "current_user" 
  # method which returns the User instance of the currently logged in user.
  module ApplicationControllerMixin
    def self.included(base)
      base.class_eval do
        protected

          def current_user
            return @current_user_cached unless @current_user_cached.nil?
    
            @current_user_cached = 
                    if session[:rbac_user_id].nil? then
                      nil # ::AnonymousUser.instance  # TODO: return nil?
                    else
                      ::User.find(session[:rbac_user_id])
                    end
    
            return @current_user_cached
          end
      end
    end
  end
end
