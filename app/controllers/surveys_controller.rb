class SurveysController < ApplicationController
  helper SurveyHelper
  layout "survey", :except => [ :show, :show_fast, :show_answer, :show_answer_fast, :show_answer2 ]
  layout "showsurvey", :only  => [ :show, :show_fast, :show_answer, :show_answer_fast, :edit, :show_answer2, :change_answer ]

  # 19-2-8 TODO: replace in_place_edit with some other edit function
  # in_place_edit_for :question, :number
  
  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => "post", :only => [ :destroy, :create, :update, :answer ],
  :redirect_to => { :action => :list }

  def index
    @page_title = "CBCL Spørgeskemaer"
    @surveys = []
    if current_user.nil?
      flash[:error] = "Du er ikke logget ind"
      redirect_to login_path
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
    render :template => 'surveys/show', :layout => "layouts/showsurvey"
  end
  
  def show_only_fast
    @options = {:show_all => true, :show_only => true, :action => 'show_answer'}
    @survey = Survey.and_questions.find(params[:id])
    @page_title = @survey.title
    render :template => 'surveys/show_fast', :layout => "layouts/showsurvey"
  end
  
  # 25-2 Changed to use params[:id] for journal_entry. Survey is found here. This means that survey can only be shown thru journal_entries
  def show                                  # 11-2 it's fastest to preload all needed objects
    @options = {:show_all => true, :action => "create"}
    @journal_entry = JournalEntry.find(params[:id])
    @survey = Rails.cache.fetch("survey_#{@journal_entry.id}") do
      Survey.find(@journal_entry.survey_id)  # 28/10 removed: .and_questions
    end
    @page_title = @survey.title

    # create survey_answer
    if @journal_entry.survey_answer.nil?  # survey_answer not created before
      journal = @journal_entry.journal
      @survey_answer = SurveyAnswer.create(:survey => @survey, :age => journal.age, :sex => journal.sex_text, 
          :surveytype => @survey.surveytype, :nationality => journal.nationality, :journal_entry => @journal_entry)
    else  # survey_answer already created, find draft
      @survey_answer = SurveyAnswer.find(@journal_entry.survey_answer_id) # 28/10 removed: .and_answer_cells
      @survey.merge_answer(@survey_answer)
      @journal_entry.survey_answer = @survey_answer
      @journal_entry.save
    end
    rescue ActiveRecord::RecordNotFound
  end

  def show_fast                             # 11-2 it's fastest to preload all needed objects
    @options = {:action => "create", :hidden => true}
    @journal_entry = JournalEntry.find(params[:id]) 
    @survey = Rails.cache.fetch("survey_#{@journal_entry.id}") do
      Survey.and_questions.find(@journal_entry.survey_id) # removed .and_questions
    end
    @page_title = @survey.title
  
    @survey_answer = nil
    if @journal_entry.survey_answer.nil?  # survey_answer not created before
      journal = @journal_entry.journal
      @survey_answer = SurveyAnswer.create(:survey => @survey, :age => journal.age, :sex => journal.sex_text, 
          :surveytype => @survey.surveytype, :nationality => journal.nationality, :journal_entry_id => @journal_entry.id)
      @survey_answer.journal_entry = @journal_entry
    else  # survey_answer was started/created, so a draft is saved
      @survey_answer = SurveyAnswer.and_answer_cells.find(@journal_entry.survey_answer_id) # removed .and_answers
      @survey.merge_answer(@survey_answer)  # insert existing answers
    end
    unless @journal_entry.survey_answer
      @journal_entry.survey_answer = @survey_answer
      @journal_entry.save
    end
    
    rescue ActiveRecord::RecordNotFound
      flash[:error] = "Kunne ikke finde skema for journal."
      redirect_to surveys_path
  end
  
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
      redirect_to surveys_path
    else
      render new_survey_path
    end
  end

  def edit
    @survey = Survey.find(params[:id])
  end

  
  def update
    @survey = Survey.find(params[:id])
    if @survey.update_attributes(params[:survey])
      flash[:notice] = 'Spørgeskemaet er opdateret.'
      redirect_to surveys_path
    else
      render :action => :edit
    end
  end

  def destroy
    Survey.destroy(params[:id])
    flash[:notice] = "Spørgeskema er slettet"
    redirect_to surveys_path
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
      elsif current_user.has_access?(:superadmin) # don't do check for superadmin
        true
      else
        journal_entry_ids = Rails.cache.fetch("journal_entry_ids_user_#{current_user.id}", :expires_in => 10.minutes) do
          current_user.journal_entry_ids
        end
        journal_entry_ids.include?(id)
      end
    end
  end
  

end
