class RolesController < ApplicationController # ActiveRbac::ComponentController
  # The RbacHelper allows us to render +acts_as_tree+ AR elegantly
  helper RbacHelper
  
  layout 'survey'

  def index
    @roles = Role.all(:include => [:groups, :users])
  end

  # Displays all roles known to the system as trees.
  def list
    @roles = Role.all(:include => [:groups, :users])
  end

  # Show a role identified by the +:id+ path fragment in the URL.
  def show
    @role = Role.find(params[:id])
    
  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'The role could not be found'
    redirect_to roles_path
  end

  def new
    @role = Role.new  
  end
  
  def create
    @role = Role.new(params[:role])

    # assign parent role
    if not params[:role][:parent].blank?
      @role.parent = Role.find(params[:role][:parent])
    end

    if @role.save
      # set the roles's static permissions to the static permission from the parameters 
      params[:role][:static_permissions] = [] if params[:role][:static_permissions].nil?
      @role.static_permissions = params[:role][:static_permissions].collect { |i| StaticPermission.find(i) }

      # the above should be successful if we reach here; otherwise we 
      # have an exception and reach the rescue block below
      flash[:success] = 'Role has been created successfully.'
      redirect_to role_path(@role)
    else
      render :action => :create
    end
    
  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'You sent an invalid request.'
    redirect_to roles_path
  end

  def edit
    @role = Role.find(params[:id])
    @roles = Role.all
  end
  
  def update
    @role = Role.find(params[:id])

    # set parent role
    if not (parent = params[:role][:parent]).blank? and !parent =~ /$on^/ 
      @role.parent = Role.find(params[:role][:parent])
    else
      @role.parent = nil
    end

    # get an array of static permissions and set the permission associations
    params[:role][:static_permissions] = [] if params[:role][:static_permissions].nil?
    permissions = params[:role][:static_permissions].collect { |i| StaticPermission.find(i) }
    @role.static_permissions = permissions

    if @role.update_attributes(params[:role])
      flash[:success] = 'Role has been updated successfully.'
      redirect_to role_path(@role)
    else
      render :action => :edit
    end
    
  rescue RecursionInTree
    @role.errors.add :parent, "must not be a descendant of itself"
    render :action => :update
  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'You sent an invalid request.'
    redirect_to roles_path
  end
  
  # Display a confirmation form (which asks "do you really want to delete this
  # role?") on GET. Handle the form submission on POST. Redirect to the "list"
  # action if the role has been deleted and redirect to the "show" action with
  # these role's id if it has not been deleted.
  def delete
    @role = Role.find(params[:id])
    
    if request.get?
      # render only
    else
      if not params[:yes].nil?
        @role.destroy
        flash[:success] = 'The role has been deleted successfully.'
        redirect_to roles_path
      else
        flash[:success] = 'The role has not been deleted.'
        redirect_to role_path(Role.find(params[:id]))
      end
    end

  rescue CantDeleteWithChildren
    flash[:error] = "You have to delete or move the role's children before attempting to delete the role itself."
    redirect_to role_path(Role.find(params[:id]))
  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'This role could not be found.'
    redirect_to roles_path
  end
  
  
  protected
  before_filter :superadmin_access
  
  def superadmin_access
    if current_user.access? :admin
      return true
    elsif !current_user.nil?
      flash[:error] = "Du har ikke adgang til denne side"
      redirect_to main_path
    else
      flash[:notice] = "Du har ikke adgang til denne side"
      redirect_to login_path
    end
  end
end
