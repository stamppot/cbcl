class SurveyController < ApplicationController
  helper SurveyHelper
  layout "survey", :except => [ :show, :show_fast, :show_answer, :show_answer_fast, :show_answer2 ]
  layout "showsurvey", :only  => [ :show, :show_fast, :show_answer, :show_answer_fast, :edit, :show_answer2, :change_answer ]

  # 19-2-8 TODO: replace in_place_edit with some other edit function
  # in_place_edit_for :question, :number
  
  def index
    redirect_to :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => "post", :only => [ :destroy, :create, :update, :answer ],
  :redirect_to => { :action => :list }

  def list
    @page_title = "CBCL Spørgeskemaer"
    @surveys = []
    if current_user.nil?
      flash[:error] = "Du er ikke logget ind"
      redirect_to :controller => 'login', :action => 'login'
    else
      @surveys = User.find(session[:rbac_user_id]).subscribed_surveys || [] #current_user.subscribed_surveys || []
      render(:layout => "layouts/survey")
    end
  end

  # start page for login-brugere
  def start
    @page_title = "CBCL Spørgeskemaer" 
    @surveys = current_user.surveys
    @entry = JournalEntry.find_by_user_id(current_user.id)
  end

  # for showing surveys without being able to answer them (sort demo-mode)
  def show_only
    @options = {:show_all => true, :show_only => true, :action => 'show_answer'}
    @survey = Survey.and_questions.find(params[:id])
    @page_title = @survey.title
    flash[:notice] = "Denne side viser ikke et brugbart spørgeskema. Du har tilgang til besvarelser gennem journaler."
    render :template => 'survey/show', :layout => "layouts/showsurvey"
  end
  
  def show_only_fast
    @options = {:show_all => true, :show_only => true, :action => 'show_answer'}
    @survey = Survey.and_questions.find(params[:id])
    @page_title = @survey.title
    render :template => 'survey/show_fast', :layout => "layouts/showsurvey"
  end
  
  # 25-2 Changed to use params[:id] for journal_entry. Survey is found here. This means that survey can only be shown thru journal_entries
  def show                                  # 11-2 it's fastest to preload all needed objects
    @options = {:show_all => true, :action => "create"}
    @journal_entry = JournalEntry.find(params[:id])
    @survey = Survey.and_questions.find(@journal_entry.survey_id)
    @page_title = @survey.title

    # create survey_answer
    if @journal_entry.survey_answer.nil?  # survey_answer not created before
      journal = @journal_entry.journal
      @survey_answer = SurveyAnswer.create(:survey => @survey, :age => journal.age, :sex => journal.sex_text, 
          :surveytype => @survey.surveytype, :nationality => journal.nationality, :journal_entry => @journal_entry)
      # @survey_answer.journal_entry = @journal_entry
    else  # survey_answer already created, find draft
      @survey_answer = SurveyAnswer.and_answer_cells.find(@journal_entry.survey_answer_id)
      @survey.merge_answer(@survey_answer)
      @journal_entry.survey_answer = @survey_answer
      @journal_entry.save
    end
    rescue ActiveRecord::RecordNotFound
  end

  def show_fast                             # 11-2 it's fastest to preload all needed objects
    @options = {:action => "create", :hidden => true}
    @journal_entry = JournalEntry.find(params[:id])
    # @@surveys[@journal_entry.survey_id]  # cached find
    @survey = Survey.and_questions.find(@journal_entry.survey_id)
    @page_title = @survey.title
  
    @survey_answer = nil
    if @journal_entry.survey_answer.nil?  # survey_answer not created before
      journal = @journal_entry.journal
      @survey_answer = SurveyAnswer.create(:survey => @survey, :age => journal.age, :sex => journal.sex_text, 
          :surveytype => @survey.surveytype, :nationality => journal.nationality, :journal_entry_id => @journal_entry.id)
      @survey_answer.journal_entry = @journal_entry
    else  # survey_answer was started/created, so a draft is saved
      @survey_answer = SurveyAnswer.and_answer_cells.find(@journal_entry.survey_answer_id)
      @survey.merge_answer(@survey_answer)  # insert existing answers
    end
    unless @journal_entry.survey_answer
      @journal_entry.survey_answer = @survey_answer
      @journal_entry.save
    end
    
    rescue ActiveRecord::RecordNotFound
      flash[:error] = "Kunne ikke finde skema for journal."
      redirect_to :list
  end
  
  # optimize Survey.find
  # def show_answer
  #   @options = {:answers => true, :disabled => true, :action => "show_answer"}
  #   @journal_entry = JournalEntry.and_survey_answer.find(params[:id])
  #   @survey_answer = SurveyAnswer.and_answer_cells.find(@journal_entry.survey_answer_id)
  #   @survey = Survey.and_questions.find(@survey_answer.survey_id)
  #   @survey.merge_answer(@survey_answer)
  #   @page_title = "CBCL - Vis Svar: " << @survey.title
  #   # render :text => @survey.to_s.inspect
  #   render :template => 'survey/show' #, :layout => "layouts/showsurvey"
  # end
  # 
  # def show_answer_fast
  #   @options = {:action => "show_answer"}
  #   @journal_entry = JournalEntry.and_survey_answer.find(params[:id])
  #   @survey_answer = @journal_entry.survey_answer
  #   @survey = Survey.and_questions.find(@journal_entry.survey_id)
  #   @survey.merge_answer(@survey_answer)
  #   @page_title = "CBCL - Vis Svar: " << @survey.title
  #   render :template => 'survey/show_fast' #, :layout => "layouts/showsurvey"
  # end
  # 
  # def change_answer
  #   @options = {:answers => true, :show_all => true, :action => "edit"}
  #   @journal_entry = JournalEntry.and_survey_answer.find(params[:id])
  #   @survey_answer = @journal_entry.survey_answer
  #   @survey = Survey.and_questions.find(@survey_answer.survey_id)
  #   @survey.merge_answer(@survey_answer)
  #   @page_title = "CBCL - Ret Svar: " << @survey.title
  #   render :template => 'survey/show'
  # end

  def finish
    login_user = LoginUser.find_by_id(params[:id])
    login_user.destroy if login_user
    
    flash[:notice] = 'Du vil nu blive logget ud.'
  end

  def new
    @survey = Survey.new
  end

  def create
    @survey = Survey.new(params[:survey])
    if @survey.save
      flash[:notice] = 'Spørgeskemaet er oprettet.'
      redirect_to :action => :list
    else
      render :action => :new
    end
  end

  def edit
    @survey = Survey.find(params[:id])
  end

  
  def update
    @survey = Survey.find(params[:id])
    if @survey.update_attributes(params[:survey])
      flash[:notice] = 'Spørgeskemaet er opdateret.'
      redirect_to :action => :list
    else
      render :action => :edit
    end
  end

  def destroy
    Survey.destroy(params[:id])
    redirect_to :action => :list
  end

  
  protected                                # 'list' only allowed for some users
  before_filter :superadmin_access, :only => [ :new, :edit, :update, :create, :delete, :destroy ]
  # before_filter :user_access, :except => [ :new, :edit, :update, :create, :destroy, :delete, :index, :list, :start, :show, :show_fast, :show_only, :answer, :end]
  # before_filter :login_access, :only => [ :index, :list, :start, :show, :show_fast, :show_only, :answer, :end ]


  def superadmin_access
    if session[:rbac_user_id] and current_user.has_access? :admin_actions
      return true
    else
      redirect_to "/main"
      flash[:error] = "Du har ikke adgang til denne side"
      return false
    end
  end
  
  def check_access
    if current_user and (current_user.has_access?(:all_users) || current_user.has_access?(:login_user))
      id = params[:id].to_i
      access = if params[:action] =~ /show_only/
        current_user.surveys.map {|s| s.id }.include? id
      else  # show methods uses journal_entry id
        current_user.journal_entry_ids.include?(id)
      end
    end
  end
  

end
