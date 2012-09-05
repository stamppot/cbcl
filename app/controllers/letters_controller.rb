class LettersController < ApplicationController
  layout 'wysiwyg'
  
  def index
    if current_user.admin?
      @letters = Letter.all
    else
      @letters = current_user.center_and_teams.map { |g| g.letters }.compact.flatten
    end
  end

  def show
    @letter = Letter.find(params[:id])
  end

  def new
    @letter = Letter.new
    @role_types = Survey.surveytypes
    @groups = if params[:id]
      used_roles = Letter.find_all_by_group_id(params[:id])
      @role_types.delete_if {|r| used_roles.include?(r.last) }
      Group.find([params[:id]])
    else
      current_user.center_and_teams
    end
    @groups = @groups.map {|g| [g.title, g.id] } if @groups.any?
    @groups.unshift ["Alle grupper", nil] if current_user.admin? && !params[:id] && !Letter.default_letters_exist?
  end

  def edit
    @letter = Letter.find(params[:id])
    @role_types = Survey.surveytypes
    @groups = current_user.center_and_teams.map {|g| [g.title, g.id] }
    @groups.unshift ["Alle grupper", nil] if current_user.admin?
  end

  def create
    @letter = Letter.new(params[:letter])
    @group = Group.find_by_id params[:letter][:group_id]
    @letter.group = @group
    
    
    existing_letter = @group.letters.select {|l| l.group_id == @group.id && l.surveytype == params[:letter][:surveytype] }
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
      render :new, :params => params and return
    end
  end

  def update
    @letter = Letter.find(params[:id])

    if @letter.update_attributes(params[:letter])
      flash[:notice] = 'Brevet er rettet.'
      redirect_to(@letter) and return
    else
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
    @letter = Letter.find_by_surveytype(entry.survey.surveytype, :conditions => ['group_id = ?', entry.journal.parent_id])
    @letter = Letter.find_by_surveytype(entry.survey.surveytype, :conditions => ['group_id = ?', entry.journal.center_id]) unless @letter
    @letter = Letter.find_default(entry.survey.surveytype) unless @letter
    if @letter
      @letter.insert_text_variables(entry)
    else
      render :text => "Brugernavn: #{entry.login_user.login}<p>Password: #{entry.password}" and return
    end
    render :layout => 'letters'
  end
  
  def show_logins
    journal = Journal.find(params[:id])
		entries = journal.not_answered_entries
    # find letter for team, center, system
		entry_letters = []
		entries.each do |entry|
    	letter = Letter.find_by_surveytype(entry.survey.surveytype, :conditions => ['group_id = ?', entry.journal.parent_id])
    	letter = Letter.find_by_surveytype(entry.survey.surveytype, :conditions => ['group_id = ?', entry.journal.center_id]) unless letter
    	letter = Letter.find_default(entry.survey.surveytype) unless letter
			entry_letters << [entry, letter]
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
      j_id = JournalEntry.find(params[:id]).journal_id
      journal_ids = cache_fetch("journal_ids_user_#{current_user.id}") { current_user.journal_ids }
      access = journal_ids.include? j_id
    end
    return access || true
  end
end
