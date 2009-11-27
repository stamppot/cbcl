# This is the controller that provides CRUD functionality for the Center model.
class CentersController < ApplicationController # < ActiveRbac::ComponentController
  # The RbacHelper allows us to render +acts_as_tree+ AR elegantly
  helper RbacHelper
  
  # Displays a tree of all centers visible to user.
  def index
    @page_title = "CBCL - Centre"
    @groups = current_user.centers
  end

  def show
    @group = Center.find(params[:id])
    @page_title = "CBCL - Center " + @group.title
    @users = User.users.in_center(@group).paginate(:all, :page => params[:page], :per_page => 15)
    @subscription_presenter = SubscriptionPresenter.new(@group)
    
    @subscriptions = @group.subscriptions
    @surveys = current_user.surveys.group_by {|s| s.id}
    
    respond_to do |format|
      format.html {
        redirect_to team_path(@group) if @group.instance_of?(Team) and return
        render
      }
      format.js {
        render :update do |page|
          page.replace_html 'users', :partial => 'shared/user_list'
        end
      }
    end
    
  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'Centeret blev ikke fundet.'
    redirect_to centers_path
  end
  
  def new
    @group = Center.find_by_id(params[:id]) || Center.new #(params[:group])
    @group.build_center_info unless @group.center_info
    
    @surveys = Survey.find(:all)
    @subscribed = Subscription.active.for_center(@group).find(:all)

    @page_title = params[:id].nil? && "Nyt Center" || "Redigering af Center"
  end

  def create
    @group = Center.new
    @group.build_center_info unless @group.center_info

    @group.update_subscriptions(params[:group].delete(:surveys) || [])
    @group.update_attributes(params[:group])

    # assign properties to group
    if @group.save
      flash[:notice] = 'Centeret er blevet oprettet.'
      redirect_to center_path(@group)
    else
      render new_center_url
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
      render new_center_url(@group)
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
    if(not params[:yes].nil?) && @group.teams.empty?
      @group.destroy
      flash[:notice] = 'Centret er blevet slettet.'
      redirect_to centers_path
    else
      flash[:notice] = 'Centret er ikke blevet slettet, da der findes underliggende teams'
      # flash[:notice] = 'Centret er ikke blevet slettet.'
      redirect_to center_path(@group)
    end

  # rescue CantDeleteWithChildren
  #   flash[:error] = "You have to delete or move the center's children before attempting to delete the group itself."
  #   redirect_to center_path(@group)
  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'Destroy: This center could not be found.'
    redirect_to centers_path
  end

  ## this is our live ajax search method
  def live_search
    @user = current_user
    @raw_phrase = (request.raw_post.gsub("&_=", "")) || params[:id]
    @groups = Center.search_title_or_code(@raw_phrase)
    @subscription_presenters = @groups.map {|g| SubscriptionPresenter.new(g)}
    
    respond_to do |wants|
      wants.html  { render(:template  => "centers/searchresults" )}
      wants.js    { render(:layout   =>  false, :template =>  "centers/searchresults" )}
    end
  end

  # show a summary view of all subscriptions
  # def show_subscriptions  # :show => active|paid|all
  #   @group = Center.find(params[:id])
  #   if current_user.access? (:subscription_show)
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
    if request.post?
      flash[:notice] = "Abonnementer er betalt." if @group.set_active_subscriptions_paid!
      redirect_to center_path(@group)
    end
    @subscription_presenter = @group.subscription_presenter
    @options = {:hide_buttons => true}
    
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
      redirect_to center_path(@group) and return if @group.save
    else
      @subscription_presenter = @group.subscription_presenter
      @options = {:hide_buttons => true}
    end
    
    rescue ActiveRecord::RecordNotFound
      flash[:error] = 'Dette abonnement kunne ikke findes.'
      redirect_to center_path(@group)
  end

  def pay_periods
    @group = Center.find params[:id]
    @start_date = date1 = params[:start_date].to_date
    @end_date = date2 = params[:end_date].to_date
    puts "PAY_PERIOD: #{params.inspect}"
    if request.post?
      @group.subscriptions.all.each do |sub|
        sub.pay_period!(date1, date2)
      end
      flash[:notice] = "Abonnementer for perioden #{date1} - #{date2} er betalt."
      redirect_to @group, :anchor => 'center_subscriptions'
    end
  end
  
  def merge_periods
    @group = Center.find params[:id]
    date1 = params[:start_date]
    date2 = params[:end_date]
    @group.subscriptions.all.each do |sub|
      sub.merge_periods!(date1, date2)
    end
  end
  
  def new_subscription_period
  end
  
  def undo_new_subscription_period
  end
  
  protected
  before_filter :user_access, :except => [ :new, :delete, :create, :edit ]
  before_filter :admin_access, :only => [ :new, :delete, :create, :edit, :pay_subscriptions, :undo_pay_subscriptions ]
  before_filter :check_access
  
  def admin_access
    if current_user.access? :admin
      return true
    elsif !current_user.nil?
      redirect_to centers_path
      flash[:notice] = "Du har ikke adgang til denne side"
      return false
    else
      redirect_to "/login"
      flash[:notice] = "Du har ikke adgang til denne side"
      access_denied
      return false
    end
  end

  def user_access
    if current_user.access? :all_users
      return true
    else
      redirect_to "/login"
      flash[:notice] = "Du har ikke adgang til denne side"
      access_denied
      return false
    end
  end
  
  def check_access
    if current_user and (current_user.access?(:all_users) || current_user.access?(:login_user))
      access = current_user.team_member? params[:id].to_i
    else
      access_denied
    end
  end
  
end