# A Journal is a special group that must be a child of a journal or center
class JournalsController < ApplicationController # < ActiveRbac::ComponentController
  # The RbacHelper allows us to render +acts_as_tree+ AR elegantly
  helper RbacHelper

  before_filter :center_title 
  before_filter :check_access, :except => [:index, :list, :per_page, :new, :live_search]

  # We force users to use POST on the state changing actions.
  # verify :method       => "post",
  # :only         => [ :create, :update, :destroy ],
  # :redirect_to  => { :action => :list },
  # :add_flash    => { :error => 'You sent an invalid request!' }
  # 
  # # We force users to use GET on all other methods, though.
  # verify :method       => :get,
  # :only         => [ :index, :list, :show, :new, :delete ],
  # :redirect_to  => { :action => :list },
  # :add_flash    => { :error => 'You sent an invalid request!' }

  def per_page
    REGISTRY[:journals_per_page]
  end
  
  def index
    @groups = current_user.journals(:page => params[:page], :per_page => per_page) || [] # TODO: Move to configuration option
  end

  def show
    @group = Rails.cache.fetch("j_#{params[:id]}") do Journal.find(params[:id], :include => :journal_entries) end
    @journal_entries = @group.journal_entries
  end

  # Displays a form to create a new group. Posts to the #create action.
  # group is the parent center
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
      Rails.cache.delete("journal_ids_user_#{current_user.id}")
      flash[:notice] = 'Journalen er oprettet.'
      redirect_to :action => 'show', :id => @group and return
    else
      @groups = Group.get_teams_or_centers(params[:id], current_user)
      @nationalities = Nationality.find(:all)
      @surveys = current_user.subscribed_surveys
      render :action => 'new'
    end

  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'Du sendte en ugyldig forespørgsel. ' + params.inspect + "<br>" + @group.errors.inspect
    redirect_to :action => :list
  end

  def edit
    @page_title = "Rediger journal"
    
    @group = Journal.find(params[:id], :include => [:person_info])
    @groups = current_user.center_and_teams
    @person_info = @group.person_info
    @nationalities = Nationality.all

  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'Denne journal kunne ikke findes.'
    redirect_to :action => :list
  end

  def update
    params[:person_info][:name] = params[:group][:title]    # save name in person_info too                                    

    @group = Journal.find(params[:id], :include => :journal_entries)
    @group.person_info.update_attributes(params[:person_info])
    @group.update_attributes(params[:group])
    @group.center = @group.parent && @group.parent.center
        
    if @group.save
      flash[:notice] = 'Journal er opdateret.'
      redirect_to :action => :show, :id => @group
    else
      @nationalities = Nationality.all
      @groups = Group.get_teams_or_centers(params[:id], current_user)
      render :action => :edit, :id => @group
    end

  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'Du sendte en ugyldig forespørgsel.'
    redirect_to :action => :list
  end

  # displays a "Do you really want to delete it?" form. It
  # posts to #destroy.
  def delete
    @group = Rails.cache.fetch("j_#{params[:id]}") do Journal.find(params[:id], :include => :journal_entries) end #Journal.find(params[:id].to_i)

  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'Journalen kunne ikke findes.'
    redirect_to :action => :list
  end

  # If the answer to the form in #delete has not been "Yes", it 
  # redirects to the #show action with the selected's group's ID.
  # Removes survey_answer for all journal_entries
  def destroy
    if not params[:yes].nil?   # slet journal gruppe
      @group = Rails.cache.fetch("j_#{params[:id]}") do Journal.find(params[:id], :include => :journal_entries) end #Journal.find(params[:id])
      @group.journal_entries.each do |entry|
        # entry.remove_login! # was: User.login_users.find(entry.user_id).destroy if entry.user_id
        entry.kill! # this removes survey_answer too! # was: JournalEntry.find(entry.id).destroy
      end
      @group.expire
      Rails.cache.delete("journal_ids_user_#{current_user.id}")
      @group.destroy # does not delete entries and users (cascading)
      flash[:notice] = "Journalen #{@group.title} er blevet slettet."
      redirect_to :action => :list
    else
      flash[:notice] = 'Journalen blev ikke slettet.'
      redirect_to :action => :show, :id => params[:id]
    end

  rescue CantDeleteWithChildren
    flash[:error] = "You have to delete or move the journal's children before attempting to delete the group itself."
    redirect_to :action => :show, :id => params[:id]
  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'Journalen kunne ikke findes.' << "  id: " << params[:id] << "   entry: " << @group.journal_entries.inspect
    redirect_to :action => :list
  end

  # don't cache variable that's changed
  def add_survey
    @group = Rails.cache.fetch("j_#{params[:id]}") do 
      Journal.find(params[:id])
    end
    if request.post?
      # @group.expire
      surveys = []
      params[:survey].each { |key,val| surveys << key if val.to_i == 1 }
      @surveys = Survey.find(surveys)
      if not @group.create_journal_entries(@surveys)
        flash[:error] = "Logins blev ikke oprettet!"
      else
        puts "add_survey: entries: #{@group.not_answered_entries.count}"
        flash[:notice] = "Spørgeskemaer blev tilføjet journal." if @group.save
      end
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

  ## this is our live ajax search method
  # TODO: search ids
  def live_search
    @raw_phrase = request.raw_post.gsub("&_=", "") || params[:id]
    @phrase = @raw_phrase.sub(/\=$/, "").sub(/%20/, " ")

    # date = @phrase.split("-")
    # # pad with zero if date-part is one cipher
    # date.map! {|d| d.length == 1 ? "0#{d}": d }  if date.size > 1
    # @phrase = case date.size
    # when 2:  # day-month, switch order
    #   date.last + "-" + date.first
    # when 3:  # day-month-year, switch order
    #   date.reverse.join("-")
    # else
    #   @phrase.downcase
    # end

    @groups =
    if @phrase.empty?
      []
    elsif current_user.has_role?(:superadmin)
      Journal.search(@phrase, :order => "created_at DESC", :include => :person_info)
    elsif current_user.has_role?(:centeradministrator)
      Journal.search(@phrase, :conditions => {:center_id => current_user.center_id}, :order => "created_at DESC", :include => :person_info)
    else
      current_user.group_ids.inject([]) do |result, id|
      result += Journal.search(@phrase, :conditions => {:parent_id => id }, :order => "created_at DESC", :include => :person_info)
      end
    end

    # @groups = current_user.journals( :per_page => 999999)
    # if @phrase.blank?
    #   @groups = []
    # else
    #   @groups = @groups.select { |g| g.title.downcase.include?(@phrase) || g.code.to_s == @phrase || g.birthdate.to_s(:db).include?(@phrase) }
    #   @groups.sort { |a, b| a.title <=> b.title }
    # end
    
    respond_to do |wants|
      wants.html  { render(:template  => "journals/searchresults" )}
      wants.js    { render(:layout   =>  false, :template =>  "journals/searchresults" )}
    end
  end
  
     
  protected
  before_filter :user_access #, :except => [ :list, :index, :show ]
  #  before_filter :protect_create, :only => [ :new, :delete, :create, :edit ]


  def protect_create
    if session[:rbac_user_id] and current_user.has_access? :all_users
      return true
    elsif !current_user.nil?
      redirect_to :action => :list
      flash[:notice] = "Du har ikke adgang til denne side"
      return false
    else
      redirect_to "/login"
      flash[:notice] = "Du har ikke adgang til denne side"
      return false
    end
  end

  def user_access
    if session[:rbac_user_id] and current_user.has_access? :journal_new_edit_delete
      return true
    else
      redirect_to "/login"
      flash[:notice] = "Du har ikke adgang til denne side"
      return false
    end
  end
  
  def check_access
    if current_user and (current_user.has_access?(:all_users) || current_user.has_access?(:login_user))
      journal_ids = Rails.cache.fetch("journal_ids_user_#{current_user.id}", :expires_in => 10.minutes) { current_user.journal_ids }
      access = journal_ids.include? params[:id].to_i
    end
  end

end
