class ScoresController < ApplicationController

  layout "survey"
  
  def index
    page = params[:page] || 1
    @scores = Score.with_survey_and_scale.all.paginate(:page => page, :per_page => per_page, :order => 'survey_id, scale ASC')
  end

  def show
    @score = Score.find(params[:id], :include => :survey)
    @page_title = @score.title + " " + @score.short_name
    @score_items_header = %w(Spg Range Kvalifikator Items)
    @score_refs_header = %w(Køn Alder Mean 95% 98%)
  end

  def new
    @score = Score.new
    @score.action = "new"
    @surveys = current_user.surveys
  end

  def create
    # render_text "params: #{params.inspect}"
    params[:score][:survey] = Survey.find(params[:score][:survey]) unless params[:score][:survey].blank?

    @score = Score.new(params[:score])
    @score.title = params[:score][:title]
    @score.scale = params[:score][:scale]
    @score.sum = params[:score][:sum]
    
    if @score.valid?
      (@score.survey.title =~ /^([A-Z]([A-Z]|\-)+)/) or (@score.survey.title =~ /([A-Z]([A-Z]|\-)+)/)
      @score.short_name = $1 || @score.survey.category
    end
    
    if @score.save #and @score.update_attributes(params[:score])
      flash[:notice] = 'Score er oprettet. Tilføj beregninger.'
      redirect_to edit_score_path(@score) #:action => :edit, :id => @score
    else
      @surveys = Survey.all(:order => :position)
      @score.action = "new"
      render new_score_path
    end
  end

  def edit
    @score = Score.find(params[:id], :include => :survey)
    @page_title = @score.title + " " + @score.short_name
    @score_items_header = %w(Spørgsmål Range Kvalifikator Items)
    @score_refs_header = %w(Køn Alder Mean 95% 98%)
  end

  def update
    @score = Score.find(params[:id])

    # params contains a new score_item that has not been created yet (happens when return is pressed)
    if params[:score_item] && params[:score_item].keys.map(&:to_i).select {|i| i==0}.size > 1 # contains new score_item
      # find curr to be updated, remove from params to new score_item
      new_score_item_params = {}
      new_score_item_params[:items] = params[:score_item].delete("items")
      new_score_item_params[:question_id] = params[:score_item].delete("question_id")
      new_score_item_params[:qualifier] = params[:score_item].delete("qualifier")
      new_score_item_params[:range] = params[:score_item].delete("range")
      new_score_item_params[:score_id] = @score.id
      new_score_item = ScoreItem.new(new_score_item_params)
      new_score_item.number = Question.find(new_score_item.question_id).number
      new_score_item.save

      ScoreItem.update(params[:score_item].keys, params[:score_item].values) # updates multiple changed values
    end
    
    # "score_ref"=>{"6"=>{"age_group"=>"4-10", "mean"=>"5", "percent95"=>"17", "gender"=>"2", "percent98"=>"20"},
    # "7"=>{"age_group"=>"11-16", "percent95"=>"23", "mean"=>"7", "gender"=>"1", "percent98"=>"29"},
    # "8"=>{"age_group"=>"11-16", "mean"=>"5", "gender"=>"2", "percent95"=>"15", "percent98"=>"22"}, 
    # "5"=>{"age_group"=>"4-10", "percent95"=>"20", "mean"=>"7", "gender"=>"1", "percent98"=>"26"}}
    # render_text params[:score_ref]
    # floats use periods, not commas. Convert input comma to period
    if params[:score_ref]   # if no references are input, means cannot be done. So check for nil!
      if params[:score_ref].keys.map(&:to_i).select {|i| i==0}.size > 1 # contains new score_ref
        # find curr to be updated, remove from params to new score_item
        new_score_ref_params = {}
        new_score_ref_params[:age_group] = params[:score_ref].delete("age_group")
        new_score_ref_params[:mean] = params[:score_ref].delete("mean")
        new_score_ref_params[:gender] = params[:score_ref].delete("gender")
        new_score_ref_params[:percent95] = params[:score_ref].delete("percent95")
        new_score_ref_params[:percent98] = params[:score_ref].delete("percent98")
        new_score_ref_params[:score_id] = @score.id
        if new_score_ref_params[:mean] =~ /(\d+)\,(\d+)/
          new_score_ref_params[:mean] = ($1 + "." + $2).to_f
        end
        new_score_ref = ScoreRef.new(new_score_ref_params)
        new_score_ref.save
      end
      params[:score_ref].each do |key,value|
        mean = params[:score_ref][key][:mean]
        if mean =~ /(\d+)\,(\d+)/
          params[:score_ref][key][:mean] = ($1 + "." + $2).to_f
        end
      end
      ScoreRef.update(params[:score_ref].keys, params[:score_ref].values)
    end

    if @score.update_attributes(params[:score])
      flash[:notice] = 'Score er opdateret.'
      redirect_to :action => :show, :id => @score
    else
      render :action => :edit
    end
  end

  def destroy
    Score.find(params[:id]).destroy
    redirect_to :action => :list
  end

  def edit_survey
    @score = Score.find(params[:id])
    
    if request.post?
      @score.survey_id = params[:score][:survey].to_i
      if @score.save
        flash[:notice] = "Spørgeskemaet blev ændret for score-beregning."
      else
        flash[:error] = "Spørgeskemaer blev ikke ændret!"
      end
      redirect_to :action => :edit, :id => @score
    else
      # render_text "score: #{@score.attributes.inspect}"
      @surveys = Survey.find(:all, :order => :position)
      @page_title = "Score-beregning #{@score.title}: Vælg spørgeskema: #{@score.inspect} -- #{params.inspect}"
      # render 'score/add_survey'
    end
  end
    
    
  #### reorder scores and scales ####
  def list_scales
    @scales = ScoreScale.find(:all)
  end
  
  def new_scale
    @scale = ScoreScale.new
  end
    
  # ajax-create scale in form. update form with created scale
  def create_scale
    @scale  = ScoreScale.new(params[:score_scale])
    @scale.save
    @scales = ScoreScale.find(:all)
      
    # update options list
    @options = @scales.map {|s| "<option value='#{s.id}' #{s.id == @scale.id ? 'selected' : ''}>#{s.title}</option>"}
    flash[:notice] = "Ny skala er oprettet."
    redirect_to :action => 'list_scales'
  end
  
  def edit_scale
    @scale = ScoreScale.find(params[:id])
  end

  def update_scale
    @scale = ScoreScale.find(params[:id])
    @scale.update_attributes(params[:score_scale])
    
    flash[:notice] = "Skala er rettet."
    render(:update) { |page| page.redirect_to :action => 'list_scales'}
  end
  
  def delete_scale
    @scale = ScoreScale.find(params[:id])
    @scale.destroy
    flash[:notice] = "Skala er slettet."
    
    redirect_to :action => 'index'
  end
  
  def show_scale
    @scales = [] << ScoreScale.find(params[:id])
    render :template => 'score/scales'
  end
  
  def order_scores
    @scale = ScoreScale.find(params[:id])
    @scores = @scale.scores.find(:all, :group => :title)
    @action = 'order'
    render :template => 'score/show_scale'
  end
  
  def done_ordering_scores
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
  
  def done_ordering_scales
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
    if session[:rbac_user_id] and current_user.has_access? :admin
      return true
    else
      redirect_to "/login"
      flash[:notice] = "Du har ikke adgang til denne side"
      return false
    end
  end
  
end
