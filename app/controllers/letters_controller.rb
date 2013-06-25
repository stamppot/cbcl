# encoding: utf-8

class LettersController < ApplicationController
  layout 'wysiwyg'
  
  def index
    if current_user.admin?  # vis ikke alle breve til admin, kun i dennes center
      @groups = [current_user.centers.first] + current_user.centers.first.children.inject([]) { |col, team| col << team if team.instance_of?(Team); col }
    else
      @groups = current_user.center_and_teams
    end
    params[:center_id] = current_user.center_id || 1
    params[:group].delete :id if params[:group] && params[:group][:id].blank?
    params[:group] ||= {:id => current_user.center_id}
    @letters = Letter.filter(params)
    @group = Group.find(params[:group][:id]) if params[:group] && !params[:group][:id].blank?
    @surveys = Survey.find([2,3,4,5])
    @survey = Survey.find_by_surveytype(params[:survey][:surveytype]) if params[:survey]
    @follow_ups = JournalEntry.follow_ups
    
    @letters = Letter.all(:conditions => 'group_id is null') + @letters if current_user.admin?
    @letters = Letter.all if params[:all]
  end

  def show
    @letter = Letter.find(params[:id])
    @page_title = @letter.name
  end

  def new
    @letter = Letter.new
    @role_types = Survey.surveytypes
    @groups = if params[:id]
      used_roles = Letter.find_all_by_group_id(params[:id])
      @role_types.delete_if {|r| used_roles.include?(r.last) }
      Group.find([params[:id]])
    else
      current_user.assigned_centers_and_teams
    end
    @groups = @groups.map {|g| [g.title, g.id] } if @groups.any?
    @groups.unshift ["Alle grupper", nil] if current_user.admin? && !params[:id] && !Letter.default_letters_exist?
    @follow_ups = JournalEntry.follow_ups
  end

  def edit
    @letter = Letter.find(params[:id])
    @role_types = Survey.surveytypes
    @groups = current_user.center_and_teams.map {|g| [g.title, g.id] }
    @groups.unshift ["Alle grupper", nil] if current_user.admin?
    @page_title = @letter.name
    @follow_ups = JournalEntry.follow_ups

    if !current_user.center_and_teams.map(&:id).include?(@letter.group_id)
	    flash[:notice] = "Kan ikke rette andres breve!" 
	    redirect_to letters_path and return
    end
    # logger.info "group_ids: #{current_user.center_and_teams.map(&:id).inspect}, letter.group: #{@letter.group_id}"
  end

  def create
    @letter = Letter.new(params[:letter])
    @group = Group.find_by_id params[:letter][:group_id]
    @letter.group = @group
    @letter.center = @group.center
    existing_letter = @group.letters.select {|l| l.group_id == @group.id && l.surveytype == params[:letter][:surveytype] && l.follow_up == params[:letter][:follow_up] }
    if existing_letter.any?
      flash[:error] = "Gruppen '#{@group.title}' har allerede et brev af typen '#{Survey.get_survey_type(@letter.surveytype)}'. V&aelig;lg en anden gruppe"
    end
    
    if @letter.save
      flash[:notice] = 'Brevet er oprettet.'
      redirect_to(@letter) and return
    else
      @group = [@letter.group.title, @letter.group.id]
      @role_types = Survey.surveytypes
      @groups = [@group]
      # @letter.follow_up = params[:letter][:follow_up].blank? && -1 || params[:letter][:follow_up].to_i
      @follow_ups = JournalEntry.follow_ups
      render :new, :params => params and return
    end
  end

  def update
    @letter = Letter.find(params[:id])
    
    if @letter.update_attributes(params[:letter])
      flash[:notice] = 'Brevet er rettet.'
      redirect_to(@letter) and return
    else
      @group = [@letter.group.title, @letter.group.id]
      @follow_ups = JournalEntry.follow_ups
      @role_types = Survey.surveytypes
      @groups = current_user.center_and_teams.map {|g| [g.title, g.id] }
      render :edit
    end
  end
  
  def destroy
      @letter = Letter.find(params[:id])
      @letter.destroy
      flash[:notice] = "Brevet #{@letter.name} er blevet slettet."
      redirect_to letters_path
  end
  
  def show_login
    entry = JournalEntry.find(params[:id], :include => :login_user)
    @login_user = entry.login_user
    # find letter for team, center, system
    @letter = Letter.find_by_priority(entry)
    if @letter.nil?
      render :text => "Intet brev fundet. Brugernavn: #{entry.login_user.login}<p>Password: #{entry.password}" and return
    end
    @letter.insert_text_variables(entry)
    @page_title = @letter.name
    render :layout => 'letters'
  end
  
  def show_logins
    journal = Journal.find(params[:id])
		entries = journal.not_answered_entries
    # find letter for team, center, system
		entry_letters = []
		entry_letters = entries.map do |entry|
      letter = Letter.find_by_priority(entry)
			[entry, letter]
		end
		@letters = entry_letters.map do |pair|
			letter = pair.last
			letter.insert_text_variables(pair.first)
			letter
		end
    render :layout => 'letters'
  end

  def mail_merge
    # find letter for team, center, system
    @letter = Letter.find(params[:id])
    @letter.to_mail_merge
    render :layout => 'letters', :template => 'letters/show_login'
  end

  def check_access
    if current_user.nil?
      redirect_to login_path and return
    end
    if ["show_login"].include?(params[:action]) && current_user and (current_user.access? :all_users)
      access = current_user.has_journal_entry? params[:id]
    end
    return access || true
  end
end
