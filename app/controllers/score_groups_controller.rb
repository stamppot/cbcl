class ScoreGroupController < ApplicationController
  layout "survey"
  
  def index
    list
    render :action => :list
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => "post", :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @score_groups = ScoreGroup.paginate(:all, :page => params[:page], :per_page => 10) 
  end

  def show
    @score_group = ScoreGroup.find(params[:id])
  end

  def show_unique
    @score_group = ScoreGroup.find(params[:id])
  end
  
  def new
    @score_group = ScoreGroup.new
  end

  def create
    @score_group = ScoreGroup.new(params[:score_group])
    if @score_group.save
      flash[:notice] = 'ScoreGroup was successfully created.'
      redirect_to :action => :list
    else
      render :action => :new
    end
  end

  def edit
    @score_groups = ScoreGroup.find(params[:id]).scores.in_groups_by {|score| score.scale }
  end

  def update
    @score_group = ScoreGroup.find(params[:id])
    if @score_group.update_attributes(params[:score_group])
      flash[:notice] = 'ScoreGroup was successfully updated.'
      redirect_to :action => :show, :id => @score_group
    else
      render :action => :edit
    end
  end

  def destroy
    ScoreGroup.find(params[:id]).destroy
    redirect_to :action => :list
  end
  
  def sort
    @score_group = ScoreGroup.find(params[:id])
    @score_group.scores.each do |score|
      score.position = params['score_group'].index(food_item.id.to_s) + 1
      score.save
    end
    render :nothing => true
  end
  
end
