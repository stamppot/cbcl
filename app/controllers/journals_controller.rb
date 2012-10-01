# encoding: utf-8

require 'iconv'
require 'excelinator'
  
# A Journal is a special group that must be a child of a journal or center
class JournalsController < ApplicationController # < ActiveRbac::ComponentController
  # The RbacHelper allows us to render +acts_as_tree+ AR elegantly
  helper RbacHelper
  cache_sweeper :journal_sweeper, :only => [:create, :update, :destroy, :add_survey, :remove_survey, :move]
  
  before_filter :check_access, :except => [:index, :list, :per_page, :new, :live_search]

  # BOM = "\377\376" #Byte Order Mark

  def per_page
    REGISTRY[:journals_per_page]
  end

  def center
    options = { :include => :parent, :page => params[:page], :per_page => per_page }
    @group = Group.find params[:id]
    @journals = Journal.for_center(@group).by_code.and_person_info.paginate(:all, :page => 1, :per_page => (journals_per_page || 20))

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
    options = { :include => :parent, :page => params[:page], :per_page => per_page }
    @journals = current_user.journals(options) || [] # TODO: Move to configuration option
  end

  def show
    @group = cache_fetch("j_#{params[:id]}") do
      Journal.find(params[:id], :include => {:journal_entries => :login_user})
    end
    alt_ids = [] # @group.center.center_settings.find(:conditions => ["name = 'alt_id_name'"])
    alt_id = alt_ids.any? && alt_ids.first || ""
    @alt_id_name = "Graviditetsnr" # alt_id && alt_id.value || "Sekundært ID"

		@answered_entries = @group.answered_entries
		@not_answered_entries = @group.not_answered_entries
  end

  def new
    @page_title = "Opret ny journal"
    @group = Journal.new
    # if journal is created from Team.show, then team is set to parent
    @groups = Group.get_teams_or_centers(params[:id], current_user)
    @group.parent, @group.center = @groups.first, @groups.first.center if @groups.any?
    # @group.code = @group.next_journal_code(current_user)
    alt_ids = [] #@group.center.center_settings.find(:conditions => ["name = 'alt_id_name'"])
    alt_id = alt_ids.any? && alt_ids.first || ""
    @alt_id_name = "Graviditetsnr" # alt_id && alt_id.value || "Sekundært ID"


    @project = Project.find(params[:project_id]) if params[:project_id]
    # @project.journals << @group if params[:project_id]
    @surveys = current_user.subscribed_surveys
    @nationalities = Nationality.all
  end

  def create
    parent = Group.find(params[:group][:parent])
    params[:person_info][:name] = params[:group][:title]
    params[:group][:center_id] = parent.is_a?(Team) && parent.center_id || parent.id
    project_params = params[:group].delete :project
    @group = Journal.new(params[:group])
    @group.person_info = @group.build_person_info(params[:person_info])

    if project_params
      @project = Project.find(project_params)
      @project.journals << @group
    end

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
    alt_id = @group.center.center_settings.first(:conditions => ["name = 'alt_id_name'"])
    @alt_id_name = alt_id && alt_id.value || "Sekundært ID"
    

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
    @group = cache_fetch("j_#{params[:id]}") do Journal.find(params[:id], :include => :journal_entries) end #Journal.find(params[:id].to_i)

  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'Journalen kunne ikke findes.'
    redirect_to journals_path
  end

  # If the answer to the form in #delete has not been "Yes", it 
  # redirects to the #show action with the selected's group's ID.
  # Removes survey_answer for all journal_entries
  def destroy
    if not params[:yes].nil?   # slet journal gruppe
      @group = cache_fetch("j_#{params[:id]}") do Journal.find(params[:id], :include => :journal_entries) end
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
      follow_up = params[:journal_entry][:follow_up]
      puts "follow_up: #{follow_up}"
      flash[:error] = "Logins blev ikke oprettet!" unless valid_entries = @group.create_journal_entries(@surveys, follow_up)
      flash[:notice] = (@surveys.size > 1 && "Spørgeskemaer " || "Spørgeskemaet ") + "er oprettet." if @group.save && valid_entries
      redirect_to @group
    else
      # can only add surveys in age group of person
      @follow_ups = JournalEntry.follow_ups
      @follow_up = @group.follow_up_count
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

    @journals =
    if @phrase.empty?
      []
    elsif current_user.has_role?(:superadmin)
      Journal.search(@phrase, :order => "created_at DESC", :include => :person_info, :per_page => 40)
    elsif current_user.has_role?(:centeradmin)
			current_user.centers.map {|c| c.id}.inject([]) do |result, id|
      	result + Journal.search(@phrase, :with => { :center_id => id }, :order => "created_at DESC", :include => :person_info, :per_page => 40)
			end
    else
      current_user.group_ids.inject([]) do |result, id|
        result += Journal.search(@phrase, :with => {:parent_id => id }, :order => "created_at DESC", :include => :person_info, :per_page => 40)
      end
    end

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

  def select_move # nb. :id is Team id!
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

  def add_journals
    project = Project.find(params[:id])
    flash[:error] = 'Ingen journaler er valgt' if params[:journals].blank?
    redirect_to project if flash[:error]
    
    journals = Journal.find(params[:journals])
    journals.each do |journal|
      project.journals << journal unless project.journals.include?(journal)
    end
    project.save
    flash[:notice] = "#{journals.size} journaler er rettet #{project.code} - #{project.name}"
    redirect_to project_path(project)
  end

  def edit_journals_email
    @project = Project.find(params[:id])
    @group = @project.center
    @page_title = "CBCL - Center " + @group.title
    @journals = @project.journals #.for_center(@group).by_code.and_person_info.paginate(:all, :page => params[:page], :per_page => journals_per_page*2, :order => 'title') || []
  end

  def update_journals_email
    params[:journals].each do |journal_params|
      journal = Journal.find(journal_params[:id])
      journal.person_info.parent_email = journal_params[:person_info][:parent_email]
      journal.person_info.save
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
      parent_entries = journal.journal_entries.select {|entry| entry.not_answered? && entry.login_user && filter.include?(entry.survey_id) }
      col << parent_entries
      col
    end.flatten

    csv = CSVHelper.new.mail_merge_login_users(journal_entries)

    respond_to do |wants|
      filename = Time.now.strftime("%Y%m%d%H%M%S") + "_logins_data_#{group.code.to_s.underscore}.csv"
      wants.html { export_csv(csv, filename) }
      wants.csv { export_csv(csv, filename) }
    end
  end

  # get login_users in all journals in team
  def export_logins
    team = Group.find(params[:id])
    csv = CSVHelper.new.login_users(team.journals)
    filename = group.title.underscore + "_" + I18n.l(Time.now, :format => :short) + "-logins.csv"
    
    respond_to do |wants|
      wants.csv { send_xsl_data 'filename' } #export_csv(csv, filename) }
      wants.xls { send_xsl_data 'filename' } #export_csv(csv, filename) }
    end    
  end

  protected
  before_filter :user_access #, :except => [ :list, :index, :show ]

  # TODO: export to xls, see export_logins_controller
  def export_csv(csv, filename, type = "application/vnd.ms-excel; charset=utf-8")
    # content = csv
    bom = "\377\376" #Byte Order Mark
    puts "BOM: #{bom} #{bom.inspect}"
    content = bom + csv # Iconv.conv("utf-16le", "utf-8", csv)
    send_data content, :filename => filename, :type => type, :content_type => type, :disposition => 'attachment'
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
    if current_user.access?(:all_users) || current_user.access?(:login_user)
      journal_ids = cache_fetch("journal_ids_user_#{current_user.id}", :expires_in => 10.minutes) { current_user.journal_ids }
      access = journal_ids.include? params[:id].to_i
    else
      redirect_to login_path and return
    end
  end

end
