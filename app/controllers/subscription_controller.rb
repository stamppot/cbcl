class SubscriptionController < ApplicationController # < ActiveRbac::ComponentController

  in_place_edit_for :subscription, :note
  
  def index
    redirect_to :action  => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => "post", :only => [ :destroy, :create, :update ],
    :redirect_to => { :action => :list }

  def list
    @page_title = "CBCL - Abonnementer på spørgeskemaer"
    # TODO: kun surveys som der er adgang til
    @user = current_user
    @options = params
    @centers = 
    if @user.has_access? :subscription_show_all
      Center.all
    elsif @user.has_access? :subscription_show
      @user.centers
    end
  end

  def show
    @page_title = "CBCL - Abonnementer på spørgeskemaer"
    @user = current_user
    @options = params  # for show options
    @subscription = Subscription.find(params[:id])
    @surveys = []
  end

  def new
    @group = Group.find(params[:id])
    @surveys = Survey.find(:all)
    @subscribed = Subscription.active.for_center(@group)
  end

   # TODO 31-1-9: possible to rewrite to use subscription id?
  def subscribe
    @group = Group.find(params[:group][:id])
    if @group.valid?
      surveys = params[:group][:surveys] || []
      subscriptions = Subscription.for_center(@group)
      subscriptions.each do |sub|
        if surveys.include? sub.survey_id.to_s   # in survey and in db
          sub.activate! unless sub.state == '1'  # activate if not active
        else   # not in surveys, but in db, so deactivate
          sub.deactivate! unless sub.state == '2'
        end
        surveys.delete sub.survey_id.to_s   # remove already done subs
      end
      # elsif not exists in db, create new subscription
      surveys.each { |survey| @group.subscriptions << Subscription.create(:center => @group, :survey_id => survey.to_i, :state => 1) }
      flash[:notice] = "Abonnementer for center #{@group.title} blev ændret."
      if @group.save
        redirect_to :controller => 'center', :action => :show , :id => @group 
      else
        flash[:error] = "Kunne ikke oprette abonnement: #{@group.errors.inspect}"
        redirect_to :action => :new, :id => @group
      end
    else
      flash[:error] = "Der er en fejl i centerets oplysninger. Check centerets kode (skal være 4 cifre)."
      redirect_to :controller => "center", :action => "edit", :id => @group
    end
  end

  # set current Copy obj to consolidated, and set up new Copy
  def consolidate
    
  end
  
  # reset counter for active copy
  def reset
    @subscription = Subscription.find(params[:id])
    if request.post?
      active_copy = @subscription.find_active_copy
      active_copy.used = 0
      flash[:notice] = "Tæller for abonnement blev nulstillet."
      redirect_to :action => :show, :id => @subscription and return if active_copy.save
    end

    rescue ActiveRecord::RecordNotFound
      flash[:error] = 'Dette abonnement kunne ikke findes.'
      redirect_to :action => :show, :id => @subscription
  end
  
  # reset counter for all copies, also paid
  def reset_all
    @subscription = Subscription.find(params[:id])
    if request.post?
      @subscription.copies.each { |copy| copy.reset! }
      flash[:notice] = "Tæller for abonnement blev nulstillet."
      redirect_to :action => :show, :id => @subscription and return if @subscription.save
    end

    rescue ActiveRecord::RecordNotFound
      flash[:error] = 'Dette abonnement kunne ikke findes.'
      redirect_to :action => :show, :id => @subscription
  end
  

  def activate
    @subscription = Subscription.find(params[:id])
    if @subscription.activate!
      flash[:notice] = "Abonnementet er aktiveret."
      redirect_to :action => :show, :id => @subscription
    end
  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'Dette abonnement kunne ikke findes.'
    redirect_to :action => :list
  end

  def deactivate
    @subscription = Subscription.active.find(params[:id])
    if @subscription.deactivate!
      flash[:notice] = "Abonnementet er deaktiveret."
      redirect_to :action => :show, :id => @subscription
    end
    
  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'Dette abonnement kunne ikke findes.'
    redirect_to :action => :list
  end

  
  protected
  before_filter :admin_access, :except => [ :list, :index, :show ]
  before_filter :subscription_show, :only => [ :list, :index, :show ]

  
  def admin_access
    if session[:rbac_user_id] and current_user.has_access? :subscription_new_edit
      return true
    elsif current_user
      redirect_to "list"
      flash[:error] = "Du har ikke adgang til denne side"
      return false
    else
      redirect_to "/login"
      flash[:error] = "Du har ikke adgang til denne side"
      return false
    end
  end

  def subscription_show
    if session[:rbac_user_id] and current_user.has_access? :subscription_show
      return true
    else
      redirect_to "list"
      flash[:notice] = "Du har ikke adgang til denne side"
      return false
    end
  end
  
end