class LettersController < ApplicationController
  layout 'wysiwyg'
  
  def index
    if current_user.admin?
      # vis ikke alle breve til admin, kun i dennes center
      @groups = [current_user.centers.first] + current_user.centers.first.children.inject([]) { |col, team| col << team if team.instance_of?(Team); col }
    else
      @groups = current_user.center_and_teams
    end
    @surveys = []
    @letters = []
    if !params[:remove_filter].blank?
      @group = Group.find(params[:group][:id]) if params[:group] && !params[:group][:id].blank?
      @surveys = Survey.find_by_surveytype(params[:survey][:surveytype]) if params[:survey] && !params[:survey][:surveytype].blank?
      @letters = @groups.map {|g| g.letters }.compact.flatten
    else
      @surveys = Survey.find([2,3,4,5])
      @letters = Letter.filter(params)
    end      
    @group = Group.find(params[:group][:id]) if params[:group] && !params[:group][:id].blank?
    @survey = Survey.find_by_surveytype(params[:survey][:surveytype]) if params[:survey]
    @follow_ups = JournalEntry.follow_ups
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
    @follow_ups = JournalEntry.follow_ups
  end

  def edit
    @letter = Letter.find(params[:id])
    @role_types = Survey.surveytypes
    @groups = current_user.center_and_teams.map {|g| [g.title, g.id] }
    @groups.unshift ["Alle grupper", nil] if current_user.admin?
    @follow_ups = JournalEntry.follow_ups
  end

  def create
    @letter = Letter.new(params[:letter])
    @group = Group.find_by_id params[:letter][:group_id]
    @letter.group = @group
    
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
    @letter = Letter.find_by_surveytype(entry.survey.surveytype, :conditions => ['group_id = ? && follow_up = ?', entry.journal.parent_id, entry.follow_up])
    @letter = Letter.find_by_surveytype(entry.survey.surveytype, :conditions => ['group_id = ? && follow_up = ?', entry.journal.center_id, entry.follow_up]) unless @letter
    @letter = Letter.find_default(entry.survey.surveytype) unless @letter
    if @letter
      @letter.insert_text_variables(entry)
      puts "Letter: #{@letter.inspect}"
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
      @letter = Letter.find_by_surveytype(entry.survey.surveytype, :conditions => ['group_id = ? && follow_up = ?', entry.journal.parent_id, entry.follow_up])
      @letter = Letter.find_by_surveytype(entry.survey.surveytype, :conditions => ['group_id = ? && follow_up = ?', entry.journal.center_id, entry.follow_up]) unless @letter
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
      access = current_user.has_journal_entry? params[:id]
    end
    return access || true
  end
end
