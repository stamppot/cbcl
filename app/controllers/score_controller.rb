class ScoreController < ApplicationController

  layout "survey"
  
  def index
    list
    render :action => :list
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => "post", :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    page = params[:page] || 1
    @scores = Score.paginate(:all, :page => page, :per_page => per_page, :include => :survey, :order => 'survey_id, scale ASC') #.in_groups_by { |score| score.scale }
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
    params[:score][:survey] = Survey.find(params[:score][:survey]) unless params[:score][:survey].nil?

    @score = Score.new(params[:score])
    # if @score.survey.nil?
    #   @score.errors.add("")
    @score.title = params[:score][:title]
    @score.scale = params[:score][:scale]
    @score.sum = params[:score][:sum]
    
    if @score.valid?
      (@score.survey.title =~ /^([A-Z]([A-Z]|\-)+)/) or (@score.survey.title =~ /([A-Z]([A-Z]|\-)+)/)
      @score.short_name = $1 || @score.survey.category
    end
    
    if @score.save #and @score.update_attributes(params[:score])
      flash[:notice] = 'Score er oprettet. Tilføj beregninger.'
      redirect_to :action => :edit, :id => @score
    else
      @surveys = Survey.find(:all, :order => :position)
      @score.action = "new"
      render :action => :new
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
      
  # Deprecated: scores-surveys are not 1-many, but 1-1
  # def add_survey
  #   @score = Score.find(params[:id]) #, :include => :surveys)
  # 
  #   if request.post?
  #     surveys = []
  #     params[:survey].each { |key,val| surveys << key if val.to_i == 1 }
  #     @surveys = Survey.find(surveys)
  #     @surveys.each { |survey| @score.surveys << survey }
  #     if @score.save
  #       flash[:notice] = "Spørgeskemaer blev tilføjet score-beregning."
  #     else
  #       flash[:error] = "Spørgeskemaer blev ikke tilføjet!" << "<br/><br/>Params: #{params.inspect}"
  #     end
  #     redirect_to :action => :edit, :id => @score
  #   else
  #     @surveys = Survey.find(:all)
  #     # remove surveys which are already associated with score
  #     @score.surveys.each { |sc_survey| @surveys.delete(sc_survey) }
  #     @page_title = "Score-beregning #{@score.title}: Tilføj spørgeskemaer"      
  #   end
  # end

  # Deprecated: scores-surveys are not 1-many, but 1-1
  # removing is a bit different than adding. This should remove the entries, the entry ids should be given in the form
  # TODO: 30-8 if any surveys for which score_items exist, remove score_items too
  # def remove_survey
  #   @score = Score.find(params[:id])
  # 
  #   if request.post?
  #     #render_text params.inspect
  #     surveys = []
  #     params[:survey].each { |key,val| surveys << key if val.to_i == 1 }
  #     @surveys = Survey.find(surveys)
  #     @surveys.each { |survey| @score.surveys.delete(survey) }
  #     if @score.save
  #       flash[:notice] = "Spørgeskemaer blev fjernet fra score-beregning."
  #       @score.surveys(true)
  #     else
  #       flash[:error] = "Spørgeskemaer blev ikke fjernet!"
  #     end
  #     redirect_to :action => :edit, :id => @score
  #   else   # collect surveys from unanswered entries
  #     @surveys = @score.surveys
  #     @page_title = "Score-beregning #{@score.title}: Fjern spørgeskemaer"      
  #   end
  # end
  
  # show new row with score_item initialized to values of the previous. ajax method
  def add_score_item
    # find most recent score_item by :id
    # create html for new row, populate it with values from score_item.
    # Survey and question must be populated with values of next unused score.surveys
    params[:score_item] = params[:score_score_item]
    @score_item = ScoreItem.new(params[:score_item])
    
    @score = Score.find(params[:id], :include => :survey)
    @score_item2 = @score.score_items.last

    if !@score.survey.nil?
      # set values from previous score item
      @score_item = ScoreItem.new
      unless @score_item2.nil?
        @score_item.items = @score_item2.items
        @score_item.range = @score_item2.range
        @score_item.qualifier = @score_item2.qualifier
        @score_item.question = @score_item2.question
      end

      # set default question to one with most items
      @score_item.question_id = @score.survey.question_with_most_items.id

      # all surveys and questions for chosen survey
      @survey = [@score.survey.title, @score.survey.id] #(true).map { |s| [s.title, s.id] } # next_survey should be selected
      @items = @score.survey.questions.map { |q| ["Spg. #{q.number} (#{q.count_items} items)", q.id] } # was q.number
      # table_header = %w(Skema Spørgsmål Range Kvalifikator Items).map { |h| "<th>#{h}</th>" }.join
    end

    # show score item form in page
    render :update do |page|
      if @score.survey.nil?
        page.alert "Tilføj først et skema"
      else
        page.show 'score_items'
        page.hide 'new_score_item_button'
        page.insert_html :bottom, 'score_items', :partial => 'add_score_item'
        page.visual_effect :blind_down, 'add_new_score_item', :duration => 2
      end
    end
  end
  
  def cancel_score_item
    render :update do |page|
      # page.hide 'score_items'
      page.replace 'add_new_score_item', ''  # remove both rows for new score item and the create/cancel buttons
      page.replace 'create_score_item_button', ''
      page.show 'new_score_item_button'
    end  
  end
  
  def create_score_item
    @score = Score.find(params[:id])
    q_no = Question.find(params[:score_item][:question_id]).number.to_s
    params[:score_item][:number] = q_no
    @score_item = ScoreItem.new(params[:score_item])
    @score.score_items << @score_item
    
    if @score.save
      render :update do |page|
        page.replace 'create_score_item_button', ''
        page.replace 'add_new_score_item', :partial => 'score_item'
        # page.insert_html :after, 'score_items', :partial => 'score_item'
        page.visual_effect :blind_down, "score_item_#{@score_item.id}"
        page.visual_effect :highlight, "score_item_#{@score_item.id}"
        page.show 'new_score_item_button'
      end
    end    
  end
  
  # deletes and updates page with ajax call
  def remove_score_item
#    @score_item = ScoreItem.find(params[:id])
    elem = "score_item_" << params[:id]

    if ScoreItem.destroy(params[:id])
      render :update do |page|
        page[elem].visual_effect :blind_up
        page[elem].remove
      end
    end
  end
  

  # # updates select with score items based on which survey is chosen
  # def update_question_items
  #   survey = Survey.find(params[:id])
  #   items = survey.questions.map { |q| ["Nr. #{q.number} (#{q.count_items} items)", q.number] }
  #   question_id = 'score_item_' + (params[:score_item].nil? ? "" : (params[:score_item] + "_")) + 'question'
  # 
  #   render :update do |page|
  #     page.replace_html question_id, options_for_select(items, survey.question_with_most_items.number)
  #     page.visual_effect :highlight, question_id, :duration => 1
  #   end
  # end
  #     
  # # update form onchange
  # def update_item_question
  #   survey = Survey.find(params[:id]) # chosen survey
  #   items = survey.questions.map { |q| ["Nr. #{q.number} (items: #{q.count_items})", q.id] }
  #   # update select for (was: all) one score item
  #   render :update do |page|
  #     page.replace "score_item_question", (select "score_item", 'question', items, { :id => "question_items" }, { :onchange => remote_function(
  #       :with => "'choice=' + this.value",
  #       :url => { :action => :update_q_items, :id => "survey_items" })})
  #       page.visual_effect :highlight, "score_item_#{@score_item.id}_question"
  #   end
  # end
  
  # methods for score references                                                                                          
  # show new row with score_ref initialized to values of the previous. ajax method                                        
  def add_score_ref
    @score_ref = ScoreRef.new #(params[:score_ref])                                                                       
    @score = Score.find(params[:id])
    @score_ref2 = @score.score_refs.last

    # set values from previous score ref                                                                                  
    @score_ref = ScoreRef.new
    unless @score_ref2.nil?
      @score_ref.survey = @score_ref2.survey
      @score_ref.gender = @score_ref2.gender % 2 + 1
      @score_ref.age_group = @score_ref2.age_group
    end

    # table_header = %w(Spørgeskema Køn Alder Mean 95% 98%).map { |h| "<th>#{h}</th>" }.join
    @surveys = [@score.survey.title, @score.survey.id] #@score.surveys.map { |s| [s.title, s.id] }

    # show score ref form in page                                                                                         
    render :update do |page|
      page.show 'score_refs'
      page.insert_html :bottom, 'score_refs', :partial => 'add_score_ref'
      page.hide 'new_score_ref_button'
      page.visual_effect :blind_down, 'add_new_score_ref', :duration => 2
    end
  end


  def cancel_score_ref
    render :update do |page|
      # page.hide 'score_refs'                                                                                            
      page.replace 'add_new_score_ref', ''  # remove both rows for new score ref and the create/cancel buttons            
      page.replace 'create_score_ref_button', ''
      page.show 'new_score_ref_button'
    end
  end


  def create_score_ref
    @score = Score.find(params[:id])
    @score_ref = ScoreRef.new(params[:score_ref])
    @score.score_refs << @score_ref

    if @score.save
      render :update do |page|
        page.replace 'create_score_ref_button', ''
        page.replace 'add_new_score_ref', ''
        page.insert_html :bottom, 'score_refs', :partial => 'score_ref'
        page.visual_effect :blind_down, "score_ref_#{@score_ref.id}"
        page.visual_effect :highlight, "score_ref_#{@score_ref.id}"
        page.show 'new_score_ref_button'
      end
    end    
  end

  # deletes and updates page with ajax call
  def remove_score_ref
    elem = "score_ref_" << params[:id]

    if ScoreRef.destroy(params[:id])
      render :update do |page|
        page[elem].visual_effect :blind_up
        page[elem].remove
      end
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
