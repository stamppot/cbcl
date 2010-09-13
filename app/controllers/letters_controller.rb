class LettersController < ApplicationController
  # layout 'cbcl', :except => [:new, :edit]
  layout 'wysiwyg' #, :only => [:new, :edit]
  
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
    @group = Group.find_by_id params[:letter][:group_id]
    @letter = Letter.new(params[:letter])
    @letter.group = @group
    
    render :new and return unless @letter.save
    flash[:notice] = 'Brevet er oprettet.'
    redirect_to(@letter)
  end

  def update
    @letter = Letter.find(params[:id])
    # params[:letter][:group] = Group.find(params[:letter][:group]) if params[:letter][:group]

    if @letter.update_attributes(params[:letter])
      flash[:notice] = 'Brevet er rettet.'
      redirect_to(@letter) and return
    else
      render :edit
    end
  end

  def destroy
    @letter = Letter.find(params[:id])
    @letter.destroy
  end
  
  def show_login
    @entry = JournalEntry.find(params[:id], :include => :login_user)
    @login_user = @entry.login_user
    # find letter for team, center, system
    @letter = Letter.find_by_surveytype(@entry.survey.surveytype, :conditions => ['group_id = ?', @entry.journal.parent_id])
    @letter = Letter.find_by_surveytype(@entry.survey.surveytype, :conditions => ['group_id = ?', @entry.journal.center_id]) unless @letter
    @letter = Letter.find_default(@entry.survey.surveytype) unless @letter
    if @letter
      @letter.insert_text_variables(@entry)
    else
      render :text => "Brugernavn: #{@entry.login_user.login}<p>Password: #{@entry.password}" and return
    end
    render
  end
  
  def check_access
    if current_user.nil?
      redirect_to login_path and return
    end
    if (params[:action] == "show_login") && current_user and (current_user.access? :all_users)
      j_id = JournalEntry.find(params[:id]).journal_id
      journal_ids = Rails.cache.fetch("journal_ids_user_#{current_user.id}") { current_user.journal_ids }
      access = journal_ids.include? j_id
    end
    return access || true
  end
end
