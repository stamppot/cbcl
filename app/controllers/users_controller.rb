class UsersController < ApplicationController # ActiveRbac::ComponentController
  layout 'cbcl'

  # The RbacHelper allows us to render +acts_as_tree+ AR elegantly
  helper RbacHelper
  
  # We force users to use POST on the state changing actions.
  verify :method       => :delete, :only => :destroy, :redirect_to => :show, :add_flash => { :error => 'Wrong request type: cannot delete'}

  before_filter :find_user, :except => [:index, :new, :create ]
  before_filter :check_access, :except => [:index, :list]

  # 31-12 Administrators cannot see other users
  def index
    @page_title = "CBCL - Liste af Brugere"
    @users = current_user.get_users(:page => params[:page], :per_page => REGISTRY[:users_per_page])
  end

  # Show a user identified by the +:id+ path fragment in the URL. Before_filter find_user
  def show
    @page_title = "CBCL - Detaljer om bruger " + @user.login
    # show all groups for current user
    @groups = @user.center_and_teams || []
  end

  # Displays a form to create a new user. Posts to the #create action.
  def new
    @roles = current_user.pass_on_roles || []  # logged-in user can give his own roles to new user
    @user = User.new
    
    if !params[:id].nil?   # create new user for specific center/team
      
      @groups = Group.this_or_parent(params[:id])
      @user.groups += @groups
    else
      @group = current_user.center || current_user.centers.first
      @groups = current_user.center_and_teams
    end
  end


  def create
    @user = current_user.create_user(params[:user])
    # assign properties to user
    if @user.save
      flash[:notice] = 'Brugeren blev oprettet.'
      redirect_to user_url(@user)
    else
      @roles = current_user.pass_on_roles || []
      @groups = current_user.center_and_teams
      render :new
    end
  end
  
  def edit
    @roles = current_user.pass_on_roles
    @groups = current_user.center_and_teams
    @user.password = ""
  end

  def update
    @user = User.find(params[:id])
    
    if current_user.update_user(@user, params[:user]) && @user.save
      flash[:notice] = 'Brugeren er ændret.'
      redirect_to user_url(@user)
    else
      @user.password = ""
      @roles  = current_user.pass_on_roles || []  # logged-in user can give his own roles to new user
      @groups = current_user.center_and_teams
      redirect_to edit_user_path(@user)
    end
  end

  # Display a confirmation form (which asks "do you really want to delete this
  # user?") on GET. Handle the form submission on POST.
  def delete
  end
  
  def destroy
    @user = User.find params[:id]
    if not params[:yes].nil?
      @user.destroy
      flash[:notice] = 'Brugeren er slettet.'
      redirect_to users_path
    else
      flash[:success] = 'Brugeren blev ikke slettet.'
      redirect_to user_url(@user)
    end
  end
  
  def change_password
    if request.get?
      @user.password = ""
    else # post
      @user.update_password(params[:user][:password])
      @user.state = 2
      @user.save
      flash[:notice] = "Dit password er ændret."
      redirect_to surveys_path
    end
  end
  
  def live_search
    @raw_phrase = request.raw_post.gsub("&_=", "") || params[:id]
    @phrase = @raw_phrase.sub(/\=$/, "").sub(/%20/, " ")

    @users =
    if @phrase.empty?
      []
    elsif current_user.has_role?(:superadmin)
      User.search(@phrase, :order => "created_at DESC")
    else
      User.search(@phrase, :with => { :center_id => current_user.center_id })
    end

    respond_to do |wants|
      wants.html  { render(:template  => "users/searchresults" )}
      wants.js    { render(:layout   =>  false, :template =>  "users/searchresults" )}
    end
  end
  
  protected
  before_filter :login_access

  def User::per_page
    REGISTRY[:default_users_paginate]
  end
   
  def find_user
    if params[:id]
      if current_user.access?(:superadmin) or current_user.access?(:admin)
        @user = User.find(params[:id])
      else
        @user = User.in_center(current_user.center).find(params[:id])
      end
    end

  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'Du sendte en ugyldig forespørgsel.'
    redirect_to users_path
  end
    
    
  def login_access
    redirect_to login_path and return unless current_user
    if current_user.access? :all_users
      return true
    elsif !current_user.nil?
      flash[:error] = "Du har ikke adgang til denne side"
      redirect_to users_path
    else
      flash[:error] = "Du har ikke adgang til denne side"
      redirect_to login_path
    end
  end
  
  def check_access
    id = params[:id].to_i
    # puts "CHECK ACCESS #{current_user.inspect}"
    redirect_to login_path and return false unless current_user
    if current_user.access?(:user_show_all)
      return true
    else
      access_list = current_user.get_users.map { |u| u.id } << 0
      unless access_list.include? id
        RAILS_DEFAULT_LOGGER.error("[ACCESS VIOLATION] current_user (#{current_user.id}) tried to access user #{id} #{params.inspect}}. Allowed list: #{access_list.inspect}")
        redirect_to login_path and return
      end
    end
    return true
  end
end