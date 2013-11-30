# encoding: utf-8

# require 'iconv'
# require 'excelinator'
  
# A Journal is a special group that must be a child of a journal or center
class JournalsController < ApplicationController # < ActiveRbac::ComponentController
  # The RbacHelper allows us to render +acts_as_tree+ AR elegantly
  helper RbacHelper
  cache_sweeper :journal_sweeper, :only => [:create, :update, :destroy, :add_survey, :remove_survey, :move]
  
  before_filter :check_access, :except => [:index, :list, :per_page, :new, :live_search]

  def per_page
    REGISTRY[:journals_per_page]
  end

  def center
    options = { :include => :group, :page => params[:page], :per_page => per_page }
    @group = Group.find params[:id]
    @journals = Journal.for_center(@group).by_code.paginate(:all, :page => 1, :per_page => (journals_per_page || 20))

    respond_to do |format|
      format.html { render :index }
      format.js {
        render :update do |page|
          page.replace_html 'journals', :partial => 'shared/journal_list'
        end
      }
    end
  end

  
  def index
    options = { :include => :group, :page => params[:page], :per_page => per_page }
    @journals = current_user.journals(options) || [] # TODO: Move to configuration option
  end

  def show
    @journal = Journal.find(params[:id]) # cache_fetch("j_#{params[:id]}") {  }
    alt_ids = [] # @journal.center.center_settings.find(:conditions => ["name = 'alt_id_name'"])
    alt_id = alt_ids.any? && alt_ids.first || ""
    @alt_id_name = "Projektnr" # alt_id && alt_id.value || "Projektnr"
		@answered_entries = @journal.answered_entries
		@not_answered_entries = @journal.not_answered_entries
  end

  def new
    @page_title = "Opret ny journal"
    @journal = Journal.new
    # if journal is created from Team.show, then team is set to parent
    @groups = current_user.my_groups
    @journal.group, @journal.center = @groups.first, @groups.first.center if @groups.any?
    alt_ids = []
    alt_id = alt_ids.any? && alt_ids.first || ""
    @alt_id_name = "AltID" # alt_id && alt_id.value || "Projektnr"
    @surveys = current_user.subscribed_surveys
    @nationalities = Nationality.all
  end

  def create
    parent = Group.find(params[:journal][:group])
    params[:journal][:group] = parent
    # params[:person_info][:name] = params[:group][:title]
    params[:journal][:center_id] = parent.is_a?(Team) && parent.center_id || parent.id
    @journal = Journal.new(params[:journal])
    # @group.person_info = @group.build_person_info(params[:person_info])
    # @group.person_info.delta = true
    @journal.delta = true # force index

    if @journal.save
      @journal.expire_cache
      flash[:notice] = 'Journalen er oprettet.'
      logger.info "Created journal, go to group: #{@journal.id}"
      redirect_to journal_path(@journal) and return
    else
      flash[:error] = @journal.errors.inspect
      @groups = Group.get_teams_or_centers(params[:id], current_user)
      @nationalities = Nationality.find(:all)
      @surveys = current_user.subscribed_surveys
      render :new
    end

  rescue ActiveRecord::RecordNotFound
    flash[:error] += 'Du sendte en ugyldig forespørgsel. ' + params.inspect + "<br>" + (@journal && @journal.errors.inspect || "")
    redirect_to journals_path
  end

  def edit
    @page_title = "Rediger journal"
    @journal = Journal.find(params[:id])
    @nationalities = Nationality.all
    alt_id = @journal.center.center_settings.first(:conditions => ["name = 'alt_id_name'"])
    @alt_id_name = alt_id && alt_id.value || "Projektnr"
    @any_answered_entries = @journal.answered_entries.any?

  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'Journalen kunne ikke findes.'
    redirect_to journals_path
  end

  def update
    @journal = Journal.find(params[:id], :include => :journal_entries)
    @journal.update_attributes(params[:journal])
        
    if @journal.save
      flash[:notice] = 'Journalen er opdateret.'
      redirect_to journal_path(@journal)
    else
      @nationalities = Nationality.all
      @groups = current_user.my_groups # Group.get_teams_or_centers(params[:id], current_user)
      render edit_journal_path(@journal)
    end

  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'Du sendte en ugyldig forespørgsel.'
    redirect_to journals_path
  end

  # displays a "Do you really want to delete it?" form. It
  # posts to #destroy.
  def delete
    @journal = Journal.find(params[:id])
  
  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'Journalen kunne ikke findes.'
    redirect_to journals_path
  end

  # If the answer to the form in #delete has not been "Yes", it 
  # redirects to the #show action with the selected's group's ID.
  # Removes survey_answer for all journal_entries
  def destroy
    if not params[:yes].nil?   # slet journal gruppe
      @journal = Journal.find(params[:id], :include => :journal_entries)
      # @group.journal_entries.map &:destroy
      @journal.destroy
      flash[:notice] = "Journalen #{@journal.title} er blevet slettet."
      redirect_to journals_path
    else
      flash[:notice] = 'Journalen blev ikke slettet.'
      redirect_to journal_path(Journal.find(params[:id]))
    end

  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'Journalen kunne ikke findes.' << "  id: " << params[:id] << "   entry: " << @journal.journal_entries.inspect
    redirect_to journals_path
  rescue => e
    flash[:error] = "Exception: #{e}"
    redirect_to journals_path
  end

  def add_survey
    @group = Journal.find(params[:id])
    if request.post?
      surveys = params[:survey].select { |k,v| v.to_i == 1 }.map &:first
      @surveys = Survey.find(surveys)
      flash[:error] = "Logins blev ikke oprettet!" unless valid_entries = @group.create_journal_entries(@surveys, params[:journal_entry][:follow_up])
      flash[:notice] = (@surveys.size > 1 && "Spørgeskemaer " || "Spørgeskemaet ") + "er oprettet." if @group.save && valid_entries
      redirect_to @group
    else       # can only add surveys in age group of person
      @follow_ups = JournalEntry.follow_ups
      @follow_up = @group.follow_up_count
      @surveys = @group.center.subscribed_surveys_in_age_group(@group.age)
      @page_title = "Journal #{@group.title}: Tilføj spørgeskemaer"      
    end
  end

  # removing is a bit different than adding. This should remove the entries, the entry ids should be given in the form  # removes login-users too
  def remove_survey
    @group = Journal.find(params[:id], :include => :journal_entries)  # 
    
    if request.post?
      entries = params[:entry].params[:survey].select { |k,v| v.to_i == 1 }.map &:first
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
    raw_phrase = request.raw_post.gsub("&_=", "") || params[:id]
    phrase = raw_phrase.sub(/\=$/, "").sub(/%20/, " ")
    # cpr.nr. søgning. Reverse
    logger.info "includes ø: " + phrase if phrase.include? "Ã¸"
    logger.info "includes ø: " + phrase if phrase.include? "ø"

    phrase = phrase.gsub("Ã¸","ø")

    phrase = phrase.split("-").join if phrase =~ /\d+-\d+-\d+/
    # phrase = phrase.split("-").reverse.join if phrase.to_i > 0

    @journals = Journal.search_journals(current_user, phrase)

    respond_to do |wants|
      wants.html  { render(:template => "journals/searchresults" )}
      wants.js    { render(:layout => false, :template => "journals/searchresults" )}
    end
  end
  
  def select
    @group = Group.find(params[:id])
    @page_title = "CBCL - Center " + @group.title
    @groups = @group.journals.paginate(:all, :page => params[:page], :per_page => journals_per_page*2, :order => 'title') || []
    @journal_count = @group.journals.count

     respond_to do |format|
       format.html
       format.js {
         render :update do |page|
           page.replace_html 'journals', :partial => 'select_journals'
         end
       }
     end

  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'Du har ikke adgang til dette center.'
    redirect_to teams_url
  end

  def select_group # nb. :id is Team id!
    @group = Journal.find(params[:id])
    @page_title = "CBCL - Center " + @group.group.title + ", team " + @group.title
    @groups = current_user.my_groups
    @journal_count = Journal.for_parent(@group).count

     respond_to do |format|
       format.html { render "select_group" }
       format.js { render :update do |page| page.replace_html 'journals', :partial => 'shared/select_journals' end }
     end

  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'Du har ikke adgang til dette team.'
    redirect_to teams_url
  end
  
  def move
    journal = Journal.find(params[:id])
    team = journal.group
    flash[:error] = 'Ingen gruppe er valgt' if params[:group].blank?
    redirect_to journal if flash[:error]

    dest = Group.find(params[:group][:group])
    journal.group = dest
    journal.save    
    flash[:notice] = "Journalen '#{journal.title}' er flyttet fra #{team.title} til #{dest.title}"
    redirect_to journal_path(journal) and return
  end

  def add_journals
    project = Project.find(params[:id])
    flash[:error] = 'Ingen journaler er valgt' if params[:journals].blank?
    redirect_to project if flash[:error]
    
    journals = Journal.find(params[:journals])
    journals.each { |journal| project.journals << journal unless project.journals.include?(journal) }
    project.save
    flash[:notice] = "#{journals.size} journaler er rettet #{project.code} - #{project.name}"
    redirect_to project_path(project)
  end

  def edit_journals_email
    @project = Project.find(params[:id])
    @group = @project.center
    @page_title = "CBCL - Center " + @group.title
    @journals = @project.journals
  end

  def update_journals_email # TODO: check where this is used, update params (was person_info, now group)
    params[:journals].each do |journal_params|
      journal = Journal.find(journal_params[:id])
      journal.parent_email = journal_params[:group][:parent_email]
      journal.save
    end
    flash[:notice] = "Forældre-mails er rettet"
    redirect_to project_path(params[:project][:id])
  end

  def export_mails
    group = Group.find(params[:id])
    filter = params[:survey] || [1,2,3,4,5]
        
    # TODO: get journal_entries for parent surveys
    journal_entries = 
    group.journals.inject([]) do |col, journal|
      # TODO: optimize queryes
      parent_entries = journal.journal_entries.select {|entry| entry.not_answered? && entry.login_user && filter.include?(entry.survey_id) }
      col << parent_entries
      col
    end.flatten

    csv_helper = ExportCsvHelper.new
    @rows = csv_helper.get_mail_merge_login_users_rows(journal_entries)
    # csv = csv_helper.to_csv(rows)

    respond_to do |wants|
      filename =  "logins_#{group.code.to_s.underscore}_#{Time.now.strftime('%Y%m%d%H%M')}.csv"
      wants.csv { export_csv csv_helper.to_csv(@rows), filename, "text/csv;charset=utf-8;" }
      wants.xls # { send_data csv_helper.to_csv(@rows, "\t"), :filename => filename, :type => "text/csv;charset=utf-8; ", :disposition => 'attachment' }  
    end
  end

  protected
  before_filter :user_access #, :except => [ :list, :index, :show ]

  # TODO: export to xls
  def export_csv(csv, filename, type = "application/vnd.ms-excel; charset=utf-8")
    bom = "\377\376"
    content = csv # Iconv.conv('utf-16le', 'utf8', csv)
    send_data content, :filename => filename, :type => type, :disposition => 'attachment'
  end

  def user_access
    redirect_to login_path and return unless current_user
    if current_user && !current_user.has_access?(:journal_new_edit_delete)
      flash[:notice] = "Du har ikke adgang til denne side"
      redirect_to login_path and return
    end
  end
  
  def check_access
    redirect_to login_path and return unless current_user
    if current_user.access?(:login_user)
      JournalEntry.find_by_id_and_user_id(params[:id], current_user.id)
    elsif current_user.access?(:all_users)
      current_user.has_journal? params[:id]
    end
  end

end
