class SubscriptionsController < ApplicationController

  in_place_edit_for :subscription, :note
  
  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => "post", :only => [ :create, :update ]

  def index
    @page_title = "CBCL - Abonnementer på spørgeskemaer"
    # TODO: kun surveys som der er adgang til
    # current_user = current_user
    @options = params
    @surveys = current_user.surveys #.group_by {|s| s.id}
    @centers = 
    if current_user.has_access? :subscription_show_all
      Center.all
    elsif current_user.has_access? :subscription_show
      current_user.centers
    end 
    
    @subscription_presenters = @centers.map do |center|
      sp = SubscriptionPresenter.new(center, @surveys)
    end

    @subscription_counts_per_center = @centers.inject({}) {|hash, center| hash[center.id] = Subscription.subscriptions_count(center); hash }
    # @subscription_summaries_per_center = @centers.inject({}) {|hash, center| hash[center.id] = center.subscription_summary(params); hash }
  end

  def show
    @page_title = "CBCL - Abonnementer på spørgeskemaer"
    # current_user = current_user
    @options = params  # for show options
    @subscription = Subscription.find(params[:id])
    t0 = Time.now
    @subscription_count = @subscription.subscriptions_count
    @group = @subscription.center
    t1 = Time.now
    @subscription_presenter = SubscriptionPresenter.new(@group, @group.surveys)
    t2 = Time.now
    @subscription_summaries = @group.subscription_summary(params)
    t3 = Time.now
    puts "Presenter: #{t2-t1}. Summary: #{t3-t2}. Count (details): #{t1-t0}. Total: #{t3-t1}"
    @surveys = []
  end

  def new
    @group = Group.find(params[:id])
    @surveys = Survey.find(:all)
    @subscribed = Subscription.active.for_center(@group)
  end

   # TODO 31-1-9: possible to rewrite to use subscription id?
  def create
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
        redirect_to center_path(@group)
      else
        flash[:error] = "Kunne ikke oprette abonnement: #{@group.errors.inspect}"
        redirect_to new_subscription_path(@group)
      end
    else
      flash[:error] = "Der er en fejl i centerets oplysninger. Check centerets kode (skal være 4 cifre)."
      redirect_to edit_center_path(@group)
    end
  end


  # reset counter for active copy
  def reset
    @subscription = Subscription.find(params[:id])
    if request.post? && params["yes"]
      active_period = @subscription.find_active_period
      active_period.used = 0
      active_period.save
      flash[:notice] = "Tæller for abonnement blev nulstillet."
    end
    redirect_to subscription_path(@subscription) 
    rescue ActiveRecord::RecordNotFound
      flash[:error] = 'Dette abonnement kunne ikke findes.'
      redirect_to subscription_path(@subscription)
  end
  
  # reset counter for all periods, also paid
  def reset_all
    @subscription = Subscription.find(params[:id])
    if request.post? && params["yes"]
      @subscription.periods.each { |copy| copy.reset! }
      flash[:notice] = "Tæller for abonnement blev nulstillet."
      @subscription.save
    end
    redirect_to subscription_path(@subscription)
    
    rescue ActiveRecord::RecordNotFound
      flash[:error] = 'Dette abonnement kunne ikke findes.'
      redirect_to subscription_path(@subscription)
  end
  

  def activate
    @subscription = Subscription.find(params[:id])
    if @subscription.activate!
      flash[:notice] = "Abonnementet er aktiveret."
      redirect_to subscription_path(@subscription)
    end
  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'Dette abonnement kunne ikke findes.'
    redirect_to subscriptions_path
  end

  def deactivate
    @subscription = Subscription.active.find(params[:id])
    if @subscription.deactivate!
      flash[:notice] = "Abonnementet er deaktiveret."
      redirect_to subscription_path(@subscription)
    end
    
  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'Dette abonnement kunne ikke findes.'
    redirect_to subscriptions_path
  end
  
    
  protected
  before_filter :admin_access, :except => [ :list, :index, :show ]
  before_filter :subscription_show, :only => [ :list, :index, :show ]

  
  def admin_access
    if current_user.access? :subscription_new_edit
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
    if current_user.access? :subscription_show
      return true
    else
      redirect_to "list"
      flash[:notice] = "Du har ikke adgang til denne side"
      return false
    end
  end
  
end