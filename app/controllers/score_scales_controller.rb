class ScoreScalesController < ApplicationController

  layout "survey"
  
  #### reorder scores and scales ####
  def index
    @scales = ScoreScale.find(:all)
  end
  
  def new
    @scale = ScoreScale.new
  end
    
  # ajax-create scale in form. update form with created scale
  def create
    @scale  = ScoreScale.new(params[:score_scale])
    @scale.save
    @scales = ScoreScale.find(:all)
      
    # update options list
    @options = @scales.map {|s| "<option value='#{s.id}' #{s.id == @scale.id ? 'selected' : ''}>#{s.title}</option>"}
    flash[:notice] = "Ny skala er oprettet."
    redirect_to :action => 'list_scales'
  end
  
  def edit
    @scale = ScoreScale.find(params[:id])
  end

  def update
    @scale = ScoreScale.find(params[:id])
    @scale.update_attributes(params[:score_scale])
    
    flash[:notice] = "Skala er rettet."
    render(:update) { |page| page.redirect_to :action => 'list_scales'}
  end
  
  def destroy
    @scale = ScoreScale.find(params[:id])
    @scale.destroy
    flash[:notice] = "Skala er slettet."
    
    redirect_to :action => 'index'
  end
  
  def show
    @scales = [] << ScoreScale.find(params[:id])
    render :template => 'score/scales'
  end
  
  def order_scores
    @scale = ScoreScale.find(params[:id])
    @scores = @scale.scores.find(:all, :group => :title)
    @action = 'order'
    render :template => 'score/show_scale'
  end
  
  def done_order_scores
    @scale = ScoreScale.find(params[:id])
    flash[:notice] = "Ny rækkefølge er gemt."
    render(:update) { |page| page.redirect_to :action => 'list_scales'}
  end
  
  def sort_scores
    @scale = ScoreScale.find(params[:id]) 
    params['score_list'].each do |score_id|
      # find score with this id, and other scores with same title. Set to same position
      score = Score.find(score_id)
      position = params['score_list'].index(score.id.to_s) + 1 
      scores = @scale.scores.find_all_by_title(score.title)
      scores.each do |score|
        score.position = position
        score.save 
      end
    end 
    render :nothing => true 
  end
  
  # order scales
  def order_scales
    @scales = ScoreScale.find(:all, :order => :position)
    @action = 'order'
  end

  def sort_scales
    @scales = ScoreScale.find(:all) 
    @scales.each do |scale|
      scale.position = params['scale_list'].index(scale.id.to_s)+1
    end
    @scales.each { |scale| scale.save_without_validation! }

    render :nothing => true 
  end
  
  def done_order_scales
    @scales = ScoreScale.find(:all)
    flash[:notice] = "Ny rækkefølge er gemt."
    render(:update) { |page| page.redirect_to :action => 'list_scales' }
  end
    
  # shows surveys for which this score applies to (or surveys for which this score has been created)
  def show_scale_surveys
    @score = Score.find(params[:id])
    @surveys = Score.find_all_by_title(@score.title, :conditions => ['score_scale_id = ?', @score.score_scale_id]).map { |score| score.survey }
    render :update do |page|
      page.replace_html 'right', :partial => 'show_scale_surveys', :object => @surveys
    end
    
  end
  
  protected
  
  def per_page
    REGISTRY[:scores_per_page]
  end
  
  # hvem har adgang til at definere scoreberegninger?  Kun superadmin og admin
  before_filter :admin_access

  
  def admin_access
    if current_user.access? :admin
      return true
    else
      redirect_to "/login"
      flash[:notice] = "Du har ikke adgang til denne side"
      return false
    end
  end
  
end
