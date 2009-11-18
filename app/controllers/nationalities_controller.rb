class NationalitiesController < ApplicationController

  layout "survey"

  def index
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
      redirect_to nationalities_path
    else
      render new_nationality_path
    end
  end

  def edit
    @nationality = Nationality.find(params[:id])
  end

  def update
    @nationality = Nationality.find(params[:id])
    if @nationality.update_attributes(params[:nationality])
      flash[:notice] = 'Nationalitet er opdateret.'
      redirect_to nationality_path(@nationality)
    else
      render :action => :edit
    end
  end

  def destroy
    Nationality.find(params[:id]).destroy
    redirect_to nationalities_path
  end

  protected
  before_filter :admin_access #, :except => [ :list, :index, :show ]

  
  def admin_access
    if current_user.access? :admin
      return true
    elsif current_user
      redirect_to nationalities_path
      flash[:notice] = "Du har ikke adgang til denne side"
      return false
    else
      redirect_to "/login"
      flash[:notice] = "Du har ikke adgang til denne side"
      return false
    end
  end

end
