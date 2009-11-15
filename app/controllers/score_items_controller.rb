class ScoreItemsController < ApplicationController

  layout "survey"
  
  # show new row with score_item initialized to values of the previous. ajax method
  def new #add_score_item
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
        page.insert_html :bottom, 'score_items', :partial => 'new_score_item'
        page.visual_effect :blind_down, 'add_new_score_item', :duration => 2
      end
    end
  end
  
  def cancel
    render :update do |page|
      # page.hide 'score_items'
      page.replace 'add_new_score_item', ''  # remove both rows for new score item and the create/cancel buttons
      page.replace 'create_score_item_button', ''
      page.show 'new_score_item_button'
    end  
  end
  
  def create # create_score_item
    @score = Score.find(params[:id])
    q_no = Question.find(params[:score_item][:question_id]).number.to_s
    params[:score_item][:number] = q_no
    @score_item = ScoreItem.new(params[:score_item])
    @score.score_items << @score_item
    
    if @score.save
      render :update do |page|
        page.replace 'create_score_item_button', ''
        page.replace 'add_new_score_item', :partial => 'scores/score_item'
        # page.insert_html :after, 'score_items', :partial => 'score_item'
        page.visual_effect :blind_down, "score_item_#{@score_item.id}"
        page.visual_effect :highlight, "score_item_#{@score_item.id}"
        page.show 'new_score_item_button'
      end
    end    
  end
  
  # deletes and updates page with ajax call
  def destroy #remove_score_item
    elem = "score_item_" << params[:id]

    if ScoreItem.destroy(params[:id])
      render :update do |page|
        page[elem].visual_effect :blind_up
        page[elem].remove
      end
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
