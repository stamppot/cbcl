# A Journal is a special group that must be a child of a journal or center
class JournalsController < ApplicationController # < ActiveRbac::ComponentController
  # The RbacHelper allows us to render +acts_as_tree+ AR elegantly
  helper RbacHelper
  cache_sweeper :journal_sweeper, :only => [:create, :update, :destroy, :add_survey, :remove_survey, :move]
  
  before_filter :check_access, :except => [:index, :list, :per_page, :new, :live_search]

  def per_page
    REGISTRY[:journals_per_page]
  end
  
  def index
    options = { :include => :parent, :page => params[:page], :per_page => per_page }
    @groups = current_user.journals(options) || [] # TODO: Move to configuration option
  end

  def show
    @group = Rails.cache.fetch("j_#{params[:id]}") do
      Journal.find(params[:id], :include => {:journal_entries => :login_user})
    end
  end

  def new
    @page_title = "Opret ny journal"
    @group = Journal.new
    # if journal is created from Team.show, then team is set to parent
    @groups = Group.get_teams_or_centers(params[:id], current_user)
    @group.parent, @group.center = @groups.first, @groups.first.center if @groups.any?
    @group.code = @group.next_journal_code(current_user)

    @surveys = current_user.subscribed_surveys
    @nationalities = Nationality.all
  end

  def create
    @group = Journal.new
    # set group title to person_info name 
    params[:person_info][:name] = params[:group][:title]
    @group.person_info = @group.build_person_info(params[:person_info])
    @group.update_attributes(params[:group])
    @group.center = @group.parent && @group.parent.center
    
    if @group.save
      @group.expire_cache
      flash[:notice] = 'Journalen er oprettet.'
      redirect_to journal_path(@group) and return
    else
      @groups = Group.get_teams_or_centers(params[:id], current_user)
      @nationalities = Nationality.find(:all)
      @surveys = current_user.subscribed_surveys
      render :new
    end

  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'Du sendte en ugyldig forespørgsel. ' + params.inspect + "<br>" + @group.errors.inspect
    redirect_to journals_path
  end

  def edit
    @page_title = "Rediger journal"
    
    @group = Journal.find(params[:id], :include => [:person_info])
    @groups = current_user.center_and_teams
    @person_info = @group.person_info
    @nationalities = Nationality.all

  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'Denne journal kunne ikke findes.'
    redirect_to journals_path
  end

  def update
    params[:person_info][:name] = params[:group][:title]    # save name in person_info too                                    

    @group = Journal.find(params[:id], :include => :journal_entries)
    @group.person_info.update_attributes(params[:person_info])
    @group.update_attributes(params[:group])
    @group.center = @group.parent && @group.parent.center
        
    if @group.save
      flash[:notice] = 'Journal er opdateret.'
      redirect_to journal_path(@group)
    else
      @nationalities = Nationality.all
      @groups = Group.get_teams_or_centers(params[:id], current_user)
      render edit_journal_path(@group)
    end

  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'Du sendte en ugyldig forespørgsel.'
    redirect_to journals_path
  end

  # displays a "Do you really want to delete it?" form. It
  # posts to #destroy.
  def delete
    @group = Rails.cache.fetch("j_#{params[:id]}") do Journal.find(params[:id], :include => :journal_entries) end #Journal.find(params[:id].to_i)

  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'Journalen kunne ikke findes.'
    redirect_to journals_path
  end

  # If the answer to the form in #delete has not been "Yes", it 
  # redirects to the #show action with the selected's group's ID.
  # Removes survey_answer for all journal_entries
  def destroy
    if not params[:yes].nil?   # slet journal gruppe
      @group = Rails.cache.fetch("j_#{params[:id]}") do Journal.find(params[:id], :include => :journal_entries) end
      @group.expire
      Rails.cache.delete("journal_ids_user_#{current_user.id}")
      @group.destroy
      flash[:notice] = "Journalen #{@group.title} er blevet slettet."
      redirect_to journals_path
    else
      flash[:notice] = 'Journalen blev ikke slettet.'
      redirect_to journal_path(Journal.find(params[:id]))
    end

  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'Journalen kunne ikke findes.' << "  id: " << params[:id] << "   entry: " << @group.journal_entries.inspect
    redirect_to journals_path
  rescue => e
    flash[:error] = "Exception: #{e}"
    redirect_to journals_path
  end

  def add_survey
    @group = Journal.find(params[:id])
    if request.post?
      surveys = []
      params[:survey].each { |key,val| surveys << key if val.to_i == 1 }
      @surveys = Survey.find(surveys)
      flash[:error] = "Logins blev ikke oprettet!" unless valid_entries = @group.create_journal_entries(@surveys)
      flash[:notice] = (@surveys.size > 1 && "Spørgeskemaer " || "Spørgeskemaet ") + "er oprettet." if @group.save && valid_entries
      redirect_to @group
    else
      # can only add surveys in age group of person
      @surveys = @group.center.subscribed_surveys_in_age_group(@group.age)
      @page_title = "Journal #{@group.title}: Tilføj spørgeskemaer"      
    end
  end

  # removing is a bit different than adding. This should remove the entries, the entry ids should be given in the form
  # removes login-users too
  def remove_survey
    @group = Journal.find(params[:id], :include => :journal_entries)  # 
    
    if request.post?
      entries = params[:entry].map { |key,val| key if val.to_i == 1 }.compact
      entries = JournalEntry.find(entries, :include => [:login_user, :survey_answer])
      entries.each { |entry| entry.destroy } # deletes user and survey_answer too

      if @group.save
        flash[:notice] = "Spørgeskemaer blev fjernet fra journal."
        @group.surveys(:reload => 'force')
        redirect_to journal_path(@group)
      end
    else   # collect surveys from unanswered entries
      @entries = @group.journal_entries.collect { |entry| entry if entry.not_answered? }.compact
      @page_title = "Journal #{@group.title}: Fjern spørgeskemaer"      
    end
  end

  def live_search
    @raw_phrase = request.raw_post.gsub("&_=", "") || params[:id]
    @phrase = @raw_phrase.sub(/\=$/, "").sub(/%20/, " ")
    # cpr.nr. søgning. Reverse
    @phrase = @phrase.split("-").reverse.join if @phrase.to_i > 0

    @groups =
    if @phrase.empty?
      []
    elsif current_user.has_role?(:superadmin)
      Journal.search(@phrase, :order => "created_at DESC", :include => :person_info, :per_page => 40)
    elsif current_user.has_role?(:centeradministrator)
      Journal.search(@phrase, :with => { :center_id => current_user.center_id }, :order => "created_at DESC", :include => :person_info, :per_page => 40)
    else
      current_user.group_ids.inject([]) do |result, id|
        result += Journal.search(@phrase, :with => {:parent_id => id }, :order => "created_at DESC", :include => :person_info, :per_page => 40)
      end
    end

    respond_to do |wants|
      wants.html  { render(:template  => "journals/searchresults" )}
      wants.js    { render(:layout   =>  false, :template =>  "journals/searchresults" )}
    end
  end
  
  def select # nb. :id is Team id!
    @group = Team.find(params[:id])
    @page_title = "CBCL - Center " + @group.parent.title + ", team " + @group.title
    @groups = Journal.for_parent(@group).by_code.and_person_info.paginate(:all, :page => params[:page], :per_page => journals_per_page*2, :order => 'title') || []
    @teams = current_user.teams
    @journal_count = Journal.for_parent(@group).count

     respond_to do |format|
       format.html
       format.js {
         render :update do |page|
           page.replace_html 'journals', :partial => 'shared/select_journals'
         end
       }
     end

  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'Du har ikke adgang til dette team.'
    redirect_to teams_url
  end
  
  def move
    team = Team.find(params[:id])
    flash[:error] = 'Ingen journaler er valgt' if params[:journals].blank?
    redirect_to team if flash[:error]
    
    dest_team = Team.find params[:team]
    journals = Journal.find(params[:journals])
    journals.each do |journal|
      journal.parent = dest_team
      journal.save
    end
    flash[:notice] = "Journaler er flyttet fra #{team.title} til team #{dest_team.title}"
    redirect_to select_journals_path(team) and return
  end
  
  protected
  before_filter :user_access #, :except => [ :list, :index, :show ]
  #  before_filter :protect_create, :only => [ :new, :delete, :create, :edit ]
  

  # def protect_create
  #   if current_user.access? :all_users
  #     return true
  #   elsif !current_user.nil?
  #     flash[:notice] = "Du har ikke adgang til denne side"
  #     redirect_to journals_path
  #   else
  #     flash[:notice] = "Du har ikke adgang til denne side"
  #     redirect_to login_path
  #   end
  # end

  def user_access
    if current_user && !current_user.access?(:journal_new_edit_delete)
      flash[:notice] = "Du har ikke adgang til denne side"
      redirect_to login_path
    end
  end
  
  def check_access
    redirect_to login_path and return unless current_user
    if current_user.access?(:all_users) || current_user.access?(:login_user)
      journal_ids = Rails.cache.fetch("journal_ids_user_#{current_user.id}", :expires_in => 10.minutes) { current_user.journal_ids }
      access = journal_ids.include? params[:id].to_i
    else
      redirect_to login_path and return
    end
  end

end
