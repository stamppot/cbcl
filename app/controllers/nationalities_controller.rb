class NationalitiesController < ApplicationController

  layout "survey"

  def index
    list
    render :action => :list
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => "post", :only => [ :destroy, :create, :update ],
  :redirect_to => { :action => :list }

  def list
    @nationalities = Nationality.paginate(:all, :page => params[:page], :per_page => 10) 
  end

  def show
    @nationality = Nationality.find(params[:id])
  end

  def new
    @nationality = Nationality.new
  end

  def create
    @nationality = Nationality.new(params[:nationality])
    if @nationality.save
      flash[:notice] = 'Nationalitet er oprettet.'
      redirect_to :action => :list
    else
      render :action => :new
    end
  end

  def edit
    @nationality = Nationality.find(params[:id])
  end

  def update
    @nationality = Nationality.find(params[:id])
    if @nationality.update_attributes(params[:nationality])
      flash[:notice] = 'Nationalitet er opdateret.'
      redirect_to :action => :show, :id => @nationality
    else
      render :action => :edit
    end
  end

  def destroy
    Nationality.find(params[:id]).destroy
    redirect_to :action => :list
  end

  protected
  before_filter :admin_access #, :except => [ :list, :index, :show ]

  
  def admin_access
    if session[:rbac_user_id] and current_user.has_access? :admin
      return true
    elsif current_user
      redirect_to "list"
      flash[:notice] = "Du har ikke adgang til denne side"
      return false
    else
      redirect_to "/login"
      flash[:notice] = "Du har ikke adgang til denne side"
      return false
    end
  end

end
