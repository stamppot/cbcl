class LoginController < ApplicationController
  caches_page :index, :logout
  
  def index
    redirect_to survey_start_path and return if current_user && current_user.login_user
    redirect_to main_path and return if current_user
  end
  
  def login
    if request.post?
      if current_user && current_user.login == params[:username]
        # user = User.find_with_credentials(params[:username], params[:password])
        # flash[:notice] = "#{current_user.name}, du er allerede logget ind."

        if current_user.login_user?
          redirect_to survey_start_path
        else
          redirect_to main_path
        end
        return
      end

      # Set the location to redirect to in the session if it was passed in through
      # a parameter and none is stored in the session.
      if session[:return_to].nil? and params[:return_to]
        session[:return_to] = params[:return_to] 
      end

      # Handle the login request otherwise.
      @errors = Array.new

      # If login or password is missing, we can stop processing right away.
      raise ActiveRecord::RecordNotFound if params[:username].to_s.empty? or params[:password].to_s.empty?

      user = User.find_with_credentials(params[:username], params[:password])    # Try to log the user in.
      raise ActiveRecord::RecordNotFound if user.nil?    # Check whether a user with these credentials could be found.
      raise ActiveRecord::RecordNotFound unless User.state_allows_login?(user.state)    # Check that the user has the correct state
      write_user_to_session(user)    # Write the user into the session object.
      if user.login_user
        cookies[:journal_entry] = JournalEntry.find_by_user_id(user.id).id
      end
      # flash[:notice] = "Velkommen #{user.name}, du er logget ind."

      # show message on first login
      if user.created_at == user.last_logged_in_at && !user.login_user
        flash[:notice] = "Husk at ændre dit password"
      end

      logger.info "LOGIN #{user.name} #{user.id} @ #{Time.now.to_s(:short)}: #{request.env['HTTP_USER_AGENT']}"

      # TODO: DRY up. Duplicate from line 27
      # if user is superadmin, redirect to login_page. Post to this method with some special parameter
      if current_user.has_access? :login_user
        redirect_to survey_start_path
      else
        redirect_to main_url
      end
    end
  rescue ActiveRecord::RecordNotFound
    # Add an error and let the action render normally.
    flash[:error] = 'Forkert brugernavn eller password' if params[:password]
    @errors << 'Ugyldigt brugernavn eller password!'
  end
  
  # Displays the logout confirmation form on GET and performs the logout on 
  # POST. Expects the "yes" parameter to be set. If this is the case, the 
  # user's authentication state is clear. If it is not the case, the use will
  # be redirected to '/'. User must be logged in
  def logout
    return unless request.post?

    # Do not log out if the user did not press the "Yes" button
    if params[:yes].nil?
      redirect_to survey_start_url and return if current_user.login_user
      redirect_to main_url and return
    end

    # Otherwise delete the user from the session
    self.remove_user_from_session!
    cookies.delete :journal_entry
    
    # Render success template.
    # flash[:notice] = "Du er blevet logget ud."
    redirect_to login_url
  end

  def shadow_logout
    set_current_user(shadow_user)
    remove_shadow_user
    flash[:notice] = "Du er blevet logget ind i din egen konto igen"
    redirect_to main_path
  end
  
  def shadow_login  
    #switch user
    to_user = User.find(params[:id])
    switch_user(current_user, to_user)
    
    #redirect to dashboard of user
    flash[:notice] = "Logget ind som en anden bruger"
    redirect_to main_url #(:controller => '/main', :index => :index)
  end

  
  protected

  def write_user_to_session(user)
    session[:rbac_user_id] = user.id
  end

  def remove_user_from_session!
    session[:rbac_user_id] = nil
  end

  # Redirects to the location stored in the <tt>return_to</tt> session 
  # entry and clears it if it is set or renders the template at the given
  # path.
  # Sets <tt>flash[:notice]</tt> to the first parameter if it redirects.
  def redirect_with_notice_or_render(notice, template)
    if session[:return_to].nil?
      render :template => template
    else
      flash[:notice] = notice
      redirect_to session[:return_to]
      session[:return_to] = nil
    end
  end

end