# This is the controller that provides CRUD functionality for the Center model.
class CentersController < ApplicationController
  # The RbacHelper allows us to render +acts_as_tree+ AR elegantly
  # helper RbacHelper
  
  def index
    @page_title = "CBCL - Centre"
    @groups = current_user.centers
		redirect_to center_url(@groups.first) if @groups.size == 1
  end

  def show
    @group = Center.find(params[:id])
    @page_title = "CBCL - Center " + @group.title
    @users = User.users.in_center(@group).paginate(:all, :page => params[:page], :per_page => 15)
    if @group.teams.size == 0
      @groups = Journal.for_parent(@group).by_code.and_person_info.paginate(:all, :page => params[:page], :per_page => journals_per_page) || []
    end
    @subscription_presenter = @group.subscription_presenter
    @subscriptions = @group.subscriptions
    @surveys = current_user.surveys.group_by {|s| s.id}
    @hide_team = true

    respond_to do |format|
      format.html { redirect_to team_path(@group) and return if @group.instance_of?(Team) }
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

    @group.subscription_service.update_subscriptions(params[:group].delete(:surveys) || [])
    # @group.update_subscriptions(params[:group].delete(:surveys) || [])
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

    @group.subscription_service.update_subscriptions(params[:group].delete(:surveys) || [])
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
    @subscription_presenters = @groups.map {|g| g.subscription_presenter }
    
    respond_to do |wants|
      wants.html  { render(:template  => "centers/searchresults" )}
      wants.js    { render(:layout   =>  false, :template =>  "centers/searchresults" )}
    end
  end

  # pay all active subscriptions
  def pay_subscriptions
    @group = Center.find(params[:id])
		puts "PAY_SUBSCRIPTIONS #{params.inspect}  group:subscription_service: #{@group.subscription_service}"
    if request.post? && params[:yes]
			# debugger
      flash[:notice] = "Abonnementer er betalt." if @group.subscription_service.pay_active_subscriptions! # @group.set_active_subscriptions_paid!
      redirect_to center_path(@group)
    end
    @subscription_presenter = @group.subscription_presenter
    @options = {:hide_buttons => true}
    
    rescue ActiveRecord::RecordNotFound
      flash[:error] = 'Dette center (abonnement) kunne ikke findes.'
      redirect_to center_path(@group) #:action => :show, :id => @group
  end
  
  # pay all active subscriptions
  def undo_pay_subscriptions
    @group = Center.find(params[:id])
    if request.post?
      @group.subscription_service.undo_pay_subscriptions!
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
    @group.subscriptions.all.each do |sub|
      sub.merge_periods!
    end
    @group.subscription_service.set_same_date_on_subscriptions!
    redirect_to subscriptions_path
  end
  
  def new_subscription_period
  end
  
  def undo_new_subscription_period
  end
  
  protected
  before_filter :admin_access, :only => [ :new, :delete, :create, :edit, :pay_subscriptions, :undo_pay_subscriptions ]
  
  def admin_access
    if !current_user.access?(:admin)
      flash[:notice] = "Du har ikke adgang til denne side"
      redirect_to centers_path
    end
  end
  
  def check_access
    redirect_to login_path unless current_user
  end
end