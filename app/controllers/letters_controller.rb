class LettersController < ApplicationController
  # layout 'cbcl', :except => [:new, :edit]
  layout 'wysiwyg' #, :only => [:new, :edit]
  
  # GET /letters
  # GET /letters.xml
  def index
    @letters = Letter.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @letters }
    end
  end

  # GET /letters/1
  # GET /letters/1.xml
  def show
    @letter = Letter.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @letter }
    end
  end

  # GET /letters/new
  # GET /letters/new.xml
  def new
    @letter = Letter.new
    @groups = if params[:id]
      Group.find([params[:id]]).map { |g| [g.title, g.id] }
    elsif Letter.first(:conditions => ['group_id IS NULL']).nil? && current_user.admin? # no letters
      ["Alle grupper", nil]
    else
      (current_user.center_and_teams - Letter.all.map(&:group)).map {|g| [g.title, g.id] }
    end
  end

  # GET /letters/1/edit
  def edit
    @letter = Letter.find(params[:id])
    @groups = current_user.center_and_teams.map {|g| [g.title, g.id] }
    @groups.unshift ["Alle grupper", nil] if current_user.admin?
  end

  # POST /letters
  # POST /letters.xml
  def create
    @group = Group.find_by_id params[:letter][:group_id]
    @letter = Letter.new(params[:letter])
    @letter.group = @group
    
    render :new and return unless @letter.save
    # if @letter.save
    flash[:notice] = 'Brevet er oprettet.'
    redirect_to(@letter)
    # else
    #   render :new
    # end
  end

  # PUT /letters/1
  # PUT /letters/1.xml
  def update
    @letter = Letter.find(params[:id])
     # params[:letter][:group] = 0 if params[:letter][:group].empty?
    params[:letter][:group_id] = nil if params[:letter][:group_id].blank?
    # @letter.group_id = 0 if params[:letter]

    if @letter.update_attributes(params[:letter])
      flash[:notice] = 'Brevet er rettet.'
      redirect_to(@letter) and return
    else
      render :edit
    end
  end

  # DELETE /letters/1
  # DELETE /letters/1.xml
  def destroy
    @letter = Letter.find(params[:id])
    @letter.destroy

    respond_to do |format|
      format.html { redirect_to(letters_url) }
      format.xml  { head :ok }
    end
  end
  
  # consider moving to letters_controller
  def show_login
    @entry = JournalEntry.find(params[:id], :include => :login_user)
    @login_user = @entry.login_user
    # find letter for team, center, system
    @letter = Letter.find_by_group_id(@entry.journal.parent_id)
    @letter = Letter.find_by_group_id(@entry.journal.center_id) unless @letter
    @letter = Letter.find_default unless @letter
    @letter.letter.gsub!('{{login}}', @login_user.login)
    @letter.letter.gsub!('{{password}}', @entry.password)
    render :layout => false
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
