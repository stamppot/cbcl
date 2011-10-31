class SurveysController < ApplicationController
  helper SurveyHelper
  layout 'cbcl', :except => [ :show, :show_fast, :show_answer, :show_answer2 ]
  layout "survey", :only  => [ :show, :show_answer, :edit, :show_answer2, :change_answer ]
	layout 'survey_print', :only => [ :print ], :except => [ :show, :show_answer, :edit, :show_answer2, :change_answer ]

  caches_page :show, :if => Proc.new { |c| entry = c.request.env['HTTP_COOKIE'].split(";").last; entry =~ /journal_entry=(\d+)/ }
  
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
      render(:layout => "layouts/cbcl")
    end
  end

  # for showing surveys without being able to answer them (sort demo-mode)
  def show_only
    @options = {:show_all => true, :show_only => true, :action => 'show_answer'}
    @survey = Survey.and_questions.find(params[:id])
    @page_title = @survey.title
    flash[:notice] = "Denne side viser ikke et brugbart spørgeskema. Du har tilgang til besvarelser gennem journaler."
    render :template => 'surveys/show', :layout => "layouts/survey"
  end
  
  def show_only_fast
    @options = {:show_all => true, :show_only => true, :action => 'show_answer'}
    @survey = Survey.and_questions.find(params[:id])
    @page_title = @survey.title
    render :template => 'surveys/show_fast', :layout => "layouts/survey_fast"
  end
  
  # 25-2 Changed to use params[:id] for journal_entry. Survey is found here. This means that survey can only be shown thru journal_entries
  def show                                  # 11-2 it's fastest to preload all needed objects
    @options = {:show_all => true, :action => "create"}
    if current_user.login_user && (journal_entry = cookies[:journal_entry])
      params[:id] = journal_entry # login user can access survey with survey_id instead of journal_entry_id
    end
    cookies.delete :user_name if current_user.login_user?  # remove flash welcome message
    
    @journal_entry = JournalEntry.find(params[:id])
    @survey = Rails.cache.fetch("survey_entry_#{@journal_entry.id}") do  # for behandlere only (only makes sense to cache if they're going to show the survey again (fx in show_fast))
      Survey.and_questions.find(@journal_entry.survey_id)  # 28/10 removed: .and_questions
    end
    @page_title = @survey.title

    # show survey with existing answers
    # login users cannot see a merged, unless a survey answer is already saved (thus he edits it, and wants to see changes)
    if survey_answer = @journal_entry.survey_answer 
      @survey.merge_survey_answer(survey_answer)
    end
    puts "SURVEY_CONTROLLER #{session[:rbac_user_id]}"

    rescue ActiveRecord::RecordNotFound
  end

  def show_fast                             # 11-2 it's fastest to preload all needed objects
    @options = {:action => "create", :hidden => true}
    @journal_entry = JournalEntry.find(params[:id]) 
    @survey = Rails.cache.fetch("survey_entry_#{@journal_entry.id}") do
      Survey.and_questions.find(@journal_entry.survey_id) # removed .and_questions
    end
    @page_title = @survey.title
  
    @survey_answer = nil
    if @journal_entry.survey_answer.nil?  # survey_answer not created before
      journal = @journal_entry.journal
      @survey_answer = SurveyAnswer.create(:survey_id => @survey.id, :age => journal.age, :sex => journal.sex_text, :journal => journal,
          :surveytype => @survey.surveytype, :nationality => journal.nationality, :journal_entry => @journal_entry)
      @survey_answer.journal_entry = @journal_entry
    else  # survey_answer was started/created, so a draft is saved
      @survey_answer = SurveyAnswer.and_answer_cells.find(@journal_entry.survey_answer_id) # removed .and_answers
      @survey.merge_survey_answer(@survey_answer)  # insert existing answers
    end
    unless @journal_entry.survey_answer
      @journal_entry.survey_answer = @survey_answer
      @journal_entry.save
    end
    render :layout => "layouts/survey_fast"
    
    rescue ActiveRecord::RecordNotFound
      flash[:error] = "Kunne ikke finde skema for journal."
      redirect_to surveys_path
  end

  def print # TODO: fetch from cache with key survey_1
    @survey = Survey.and_questions.find(params[:id])
    @page_title = "CBCL - Udskriv Spørgeskema: " << @survey.title
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
    expire_page :action => :show, :id => @survey

    if @survey.update_attributes(params[:survey])
      flash[:notice] = 'Spørgeskemaet er opdateret.'
      redirect_to surveys_path
    else
      render :edit
    end
  end

  def destroy
    Survey.destroy(params[:id])
    flash[:notice] = "Spørgeskema er slettet"
    redirect_to surveys_path
  end

  
  protected
  
  before_filter :superadmin_access, :only => [ :new, :edit, :update, :create, :delete, :destroy ]


  def superadmin_access
    unless current_user.access? :superadmin
      flash[:error] = "Du har ikke adgang til denne side"
      redirect_to main_path
    end
  end
  
  def check_access
    redirect_to login_path and return unless current_user
    if current_user.access?(:all_users) || current_user.access?(:login_user)
      id = params[:id].to_i
      access = if params[:action] =~ /show_only/
        current_user.surveys.map {|s| s.id }.include? id
      elsif current_user.access? :superadmin # don't do check for superadmin
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
