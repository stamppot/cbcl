# This is the controller that provides CRUD functionality for the Center model.
class CentersController < ApplicationController # < ActiveRbac::ComponentController
  # The RbacHelper allows us to render +acts_as_tree+ AR elegantly
  helper RbacHelper
  
  # Use the configured layout.
  # # layout ActiveRbacConfig.config(:controller_layout)

  # We force users to use POST on the state changing actions.
  verify :method       => :delete, :only => :destroy, :redirect_to => :show, :add_flash => { :error => 'Wrong request type: cannot delete'}
  
  verify :method       => "post",
         :only         => [ :create, :update ],
         :redirect_to  => { :action => :list },
         :add_flash    => { :error => 'You sent an invalid request!' }
          
  # We force users to use GET on all other methods, though.
  verify :method       => :get,
         :only         => [ :index, :list, :show, :delete ],
         :redirect_to  => { :action => :list },
         :add_flash    => { :error => 'Center: You sent an invalid request!' }

  # Simply redirects to #list
  # Displays a tree of all centers visible to user.
  def index
    @page_title = "CBCL - Centre"
    @groups = current_user.centers
  end

  def show
    @group = Center.find(params[:id])
    @page_title = "CBCL - Center " + @group.title
    @copies = @group.subscription_summary(params)
    @users = User.users.in_center(@group).paginate(:all, :page => params[:page], :per_page => 15)
    
    redirect_to team_path(@group) if @group.instance_of?(Team) and return
    
  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'Vis: Centeret blev ikke fundet.'
    redirect_to centers_path
  end
  
  # replaces new, create, edit, update by using postback action (recipe 33)
  def new
    @group = Center.find_by_id(params[:id]) || Center.new #(params[:group])
    @group.build_center_info unless @group.center_info
    
    @surveys = Survey.find(:all)
    @subscribed = Subscription.active.for_center(@group).find(:all)

    @page_title = params[:id].nil? && "Nyt Center" || "Redigering af Center"

    if request.post?
      @group.update_subscriptions(params[:group].delete(:surveys) || [])
      @group.update_attributes(params[:group])

      # assign properties to group
      if @group.save
        flash[:notice] = 'Centeret er blevet ' + (params[:id].nil? ? 'oprettet.' : 'opdateret')
        params[:id].nil? ? redirect_to(center_path(@group)) : redirect_to(centers_path)
      else
        render :action => :new
      end
    end
  end

  def edit
    @group = Center.find_by_id(params[:id])
    @group.build_center_info unless @group.center_info
    @surveys = Survey.find(:all)
    @subscribed = Subscription.active.for_center(@group).find(:all)
    @page_title = "Redigering af Center"
  end

  def update
    @group = Center.find_by_id(params[:id])
    @group.build_center_info unless @group.center_info

    @group.update_subscriptions(params[:group].delete(:surveys) || [])
    @group.update_attributes(params[:group])

    # assign properties to group
    if @group.save
      flash[:notice] = 'Centeret er blevet opdateret'
      redirect_to(centers_path)
    else
      render :action => :new
    end
  end
  
  # Loads the group specified by the :id parameters from the url fragment from
  # the database and displays a "Do you really want to delete it?" form. It
  # posts to #destroy.
  def delete
    @group = Center.find(params[:id])

  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'Delete: This center could not be found.'
    redirect_to centers_path #:action => :list
  end

  # Removes a group record from the database. +destroy+ is only accessible
  # via POST. If the answer to the form in #delete has not been "Yes", it 
  # redirects to the #show action with the selected's group's ID.
  def destroy
    @group = Center.find(params[:id])
    if not params[:yes].nil?
      @group.destroy
      flash[:notice] = 'Centret er blevet slettet.'
      redirect_to :action => :list
    else
      flash[:notice] = 'Centret er ikke blevet slettet.'
      redirect_to center_path(@group)
    end

  rescue CantDeleteWithChildren
    flash[:error] = "You have to delete or move the center's children before attempting to delete the group itself."
    redirect_to center_path(@group)
  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'Destroy: This center could not be found.'
    redirect_to centers_path
  end

  ## this is our live ajax search method
  def live_search
    @user = current_user
    @raw_phrase = request.raw_post || params[:id]
    @groups = Center.search_title_or_code(@raw_phrase)
    respond_to do |wants|
      wants.html  { render(:template  => "centers/searchresults" )}
      wants.js    { render(:layout   =>  false, :template =>  "centers/searchresults" )}
    end
  end

  # show a summary view of all subscriptions
  # def show_subscriptions  # :show => active|paid|all
  #   @group = Center.find(params[:id])
  #   if current_user.has_access?(:subscription_show)
  #     @copies = @group.subscription_summary(:show => params[:show])
  #     render "shared/subscription_summary"
  #   else
  #     flash[:error] = "Du har ikke adgang til denen side."
  #     redirect_to :action => :show, :id => @group
  #   end
  # end

  # pay all active subscriptions
  def pay_subscriptions
    @group = Center.find(params[:id])
    @copies = @group.subscription_summary(:show => params[:show])
    if request.post?
      @group.set_active_subscriptions_paid!
      flash[:notice] = "Abonnementer er betalt."
      redirect_to center_path(@group) #:action => :show, :id => @group and return if @group.save
    end
    
    rescue ActiveRecord::RecordNotFound
      flash[:error] = 'Dette abonnement kunne ikke findes.'
      redirect_to center_path(@group) #:action => :show, :id => @group
  end
  
  # pay all active subscriptions
  def undo_pay_subscriptions
    @group = Center.find(params[:id])
    if request.post?
      @group.undo_pay_subscriptions!
      flash[:notice] = "Sidste betaling af abonnementer er fortrudt."
      redirect_to center_path(@group) and return if @group.save #:action => :show, :id => @group and return if @group.save
    else
      @copies = @group.subscription_summary(:show => params[:show])
    end
    
    rescue ActiveRecord::RecordNotFound
      flash[:error] = 'Dette abonnement kunne ikke findes.'
      redirect_to center_path(@group) #:action => :show, :id => @group
  end
  
  protected
  before_filter :user_access, :except => [ :new, :delete, :create, :edit ]
  before_filter :admin_access, :only => [ :new, :delete, :create, :edit, :pay_subscriptions, :undo_pay_subscriptions ]
  before_filter :check_access
  
  def admin_access
    if session[:rbac_user_id] and current_user.has_access? :admin
      return true
    elsif !current_user.nil?
      redirect_to "/center/list"
      flash[:notice] = "Du har ikke adgang til denne side"
      return false
    else
      redirect_to "/login"
      flash[:notice] = "Du har ikke adgang til denne side"
      return false
    end
  end

  def user_access
    if session[:rbac_user_id] and current_user.has_access? :all_users
      return true
    else
      redirect_to "/login"
      flash[:notice] = "Du har ikke adgang til denne side"
      return false
    end
  end
  
  def check_access
    if current_user and (current_user.has_access?(:all_users) || current_user.has_access?(:login_user))
      access = current_user.team_member? params[:id].to_i
    end
  end
  
end