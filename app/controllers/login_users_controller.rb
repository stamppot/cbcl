class LoginUsersController < ApplicationController # < ActiveRbac::ComponentController
  helper RbacHelper

  # We force users to use POST on the state changing actions.
  verify :method       => "post",
         :only         => [ :create, :update, :destroy ],
         :redirect_to  => { :action => :list },
         :add_flash    => { :error => 'You sent an invalid request!' }

  # We force users to use GET on all other methods, though.
  verify :method       => :get,
         :only         => [ :index, :list, :show, :new, :delete ],
         :redirect_to  => { :action => :list },
         :add_flash    => { :error => 'You sent an invalid request!' }
  

  # Simply redirects to #list
  # Displays a paginated table of login-users.
  # 25-5 move login_users to center model.
  def index
    @page_title = "CBCL - Liste af login-brugere"
    @user = current_user
    @users = @user.login_users({:page => params[:page], :per_page => REGISTRY[:login_users_per_page]})
    render :template => 'users/index'
  end

  # Show a user identified by the +:id+ path fragment in the URL.
  # Shows more groups for users with high roles. Is this the idea?
  def show
      @user = LoginUser.find(params[:id].to_i)
      @page_title = "CBCL - Detaljer om login-bruger " + @user.login

      # show all groups for current user
      @groups = @user.center_and_teams
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = 'Denne bruger kunne ikke findes.'
      redirect_to :action => :list
  end

  # Displays a form to create a new user. Posts to the #create action.
  # Login-user must be part of journal group
  def new
    @user = LoginUser.new
    @entry = JournalEntry.find(params[:id])
    @group = @entry.journal
    @surveytype = params[:surveytype]
    @roles = []
    unless @surveytype.nil?
      @roles += (Role.find :all, :conditions => [ 'title = ?', @surveytype ])
    else
      @roles += Role.find :all, :conditions => [ 'title = ? OR title = ? OR title = ? OR title = ?', 'parent', 'teacher', 'youth', 'pedagogue' ]
    end
    @page_title = "Ny login-bruger for journal #{@group.title}"
  end

  # Creates a new user. +create+ is only accessible via POST and renders
  # the same form as #new on validation errors.
  # def create
  #   @user = LoginUser.new(params[:user])
  #   @entry = JournalEntry.find(params[:id])
  #   @group = @entry.journal
  #   @entry.login_user = @user
  #   @entry.awaiting_answer
  #   # in case of error, roles and groups must be set to render form again
  #   params[:user][:roles] = [] if params[:user][:roles].nil?
  #   params[:user][:groups] = [] if params[:user][:groups].nil?
  #   @user.password = params.delete(:password)
  #   @user.password_confirmation = params.delete(:password_confirmation)
  # 
  #   @groups = Group.find(params[:user].delete(:groups)) # ].collect { |i| Group.find(i) }
  #   
  #   @roles = params[:user][:roles].collect { |i| Role.find(i) }
  #   @user.roles = @roles
  #   @user.groups = @groups << @group
  #   @user.password_hash_type = "md5"
  #   
  #    # assign properties to user
  #    if @user.valid? and @entry.save and @user.save
  #      flash[:notice] = 'Login-bruger blev oprettet.'
  #      redirect_to login_user_path(@user)
  #    else
  #      flash[:errors] = "Login-brugeren kunne ikke oprettes."
  #      render :action => :new, :id => @group, :surveytype => @surveytype
  #    end
  # 
  # rescue ActiveRecord::RecordNotFound
  #   flash[:error] = 'You sent an invalid request.'
  # #  redirect_to :action => :list
  # end

  # Loads the user identified by the :id parameter from the url fragment from
  # the database and displays an edit form with the user.
  def edit
    @user = User.find(params[:id])
    @login_role = Role.find(:first, :conditions => ['title = ? ', :loginbruger] )
    @roles = @user.roles
  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'You sent an invalid request.'
    redirect_to :action => :list
  end

  # Updates a user record in the database. +update+ is only accessible via
  # POST and renders the same form as #edit on validation errors.
  def update
    @user = User.find(params[:id])

    # get an array of roles and set the role associations
    params[:user][:roles] = [] if params[:user][:roles].nil?
    params[:user][:groups] = [] if params[:user][:groups].nil?
    @groups = Group.find(params[:user].delete(:groups)) # ].collect { |i| Group.find(i) }
    @roles = params[:user][:roles].collect { |i| Role.find(i) }
    @user.center = @groups.first.center unless @groups.empty?
    @user.roles = @roles
    @user.groups = @groups
    
    unless params[:password].empty?
      @user.password = params.delete(:password)
      @user.password_confirmation = params.delete(:password_confirmation)
    end
    
    # Bulk-Assign the other attributes from the form.
    if @user.valid? and @user.update_attributes(params[:user])
      @user.save
      flash[:notice] = 'Brugeren er opdateret.'
      redirect_to :action => :show, :id => @user
    else
      render :edit
    end

  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'You sent an invalid request.'
    redirect_to :action => :list
  end
  
  # Loads the user specified by the :id parameters from the url fragment from
  # the database and displays a "Do you really want to delete it?" form. It
  # posts to #destroy.
  def delete
    @user = User.find(params[:id])
  rescue
    flash[:notice] = 'Ugyldig bruger angivet!'
    redirect_to journals_path
  end

  
  # Removes a user record from the database. +destroy+ is only accessible
  # via POST. If the answer to the form in #delete has not been "Yes", it 
  # redirects to the #show action with the selected's userp's ID.
  def destroy
    @user = User.find(params[:id])
    if not params[:yes].nil?
      # remove user from journalentry
      @entry = JournalEntry.find(:first, :conditions => [ 'user_id = ?', @user.id ])
      @entry.remove_login_user!   # remove user and reset state unless answered
      @journal = @entry.journal
      @user.destroy
      flash[:notice] = 'Brugeren er blevet slettet.'
      redirect_to journal_path(@journal)
    else
      flash[:notice] = 'Brugeren er ikke blevet slettet.'
      redirect_to journal_path(@journal)
    end
    
  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'Brugeren kunne ikke findes.'
    redirect_to journal_path(@journal)
  end
  
  protected
  before_filter :user_access

  def user_access
    if current_user.access? :all_users
      return true
    else
      redirect_to "/login"
      flash[:notice] = "Du har ikke adgang til denne side"
      return false
    end
  end
  
  def check_access
    return true if current_user.admin?
    return false unless current_user
    if current_user.access?(:all_users) || current_user.access?(:login_user)
      access = current_user.journals.map {|j| j.journal_entries.map {|je| je.user_id }}.include? params[:id].to_i
    end
  end
  
  
end
