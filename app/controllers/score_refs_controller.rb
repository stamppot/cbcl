class ScoreRefsController < ApplicationController

  layout "survey"
  
  # show new row with score_ref initialized to values of the previous. ajax method                                        
  def new
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

    @surveys = [@score.survey.title, @score.survey.id]

    # show score ref form in page                                                                                         
    render :update do |page|
      page.show 'score_refs'
      page.insert_html :bottom, 'score_refs', :partial => 'new_score_ref'
      page.hide 'new_score_ref_button'
      page.visual_effect :blind_down, 'add_new_score_ref', :duration => 2
    end
  end


  def cancel
    render :update do |page|
      # page.hide 'score_refs'                                                                                            
      page.replace 'add_new_score_ref', ''  # remove both rows for new score ref and the create/cancel buttons            
      page.replace 'create_score_ref_button', ''
      page.show 'new_score_ref_button'
    end
  end


  def create #create_score_ref
    @score = Score.find(params[:id])
    @score_ref = ScoreRef.new(params[:score_ref])
    @score.score_refs << @score_ref

    if @score.save
      render :update do |page|
        # page.remove 'create_score_ref_button'
        page.replace 'create_score_ref_button', ''
        page.replace 'add_new_score_ref', ''
        page.insert_html :bottom, 'score_refs', :partial => 'scores/score_ref'
        page.visual_effect :blind_down, "score_ref_#{@score_ref.id}"
        page.visual_effect :highlight, "score_ref_#{@score_ref.id}"
        page.show 'new_score_ref_button'
      end
    end    
  end

  def destroy
    elem = "score_ref_" << params[:id]

    if ScoreRef.destroy(params[:id])
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
