class TeamsController < ApplicationController # < ActiveRbac::ComponentController
  # The RbacHelper allows us to render +acts_as_tree+ AR elegantly
  helper RbacHelper

  def login_users
    @team = Team.find(params[:id])
    
    respond_to do |wants|
      wants.html {
        @users = @team.login_users
        @users = WillPaginate::Collection.create(1, @users.size + 1) do |pager|
             # inject the result array into the paginated collection:
             pager.replace(@users)
        	 end
      }
      wants.csv {
        csv = CSVHelper.new.login_users(@team.journals)
        
        send_data(csv, :filename => Time.now.strftime("%Y%m%d") + "_login_brugere_team_#{@team.title.underscore}.csv", 
                  :type => 'text/csv', :disposition => 'attachment')
      }
    end
  end

  # problem: does not reload when adding new team!!!
  # Displays a tree of all projects.
  def index
    @page_title = "CBCL - Liste af teams"
		@hide_team = true
    # @teams_by_center = current_user.teams.group_by { |team| team.center }
    @teams = current_user.teams

    respond_to do |format|
      format.html
      format.js {
        @teams = Team.all(:conditions => ['parent_id = ?', params[:id]], :order => "title")
        render :update do |page|
          if @teams.any?
            page.visual_effect :highlight, 'teams'
            page.replace_html 'teams', :partial => 'list'
            page.show 'teams'
          else
            page.hide 'teams'
          end
        end
      }
    end
  end

  def show
    @group = Team.find(params[:id])
    @page_title = "CBCL - Center " + @group.parent.title + ", team " + @group.title
    @journals = Journal.for_parent(@group).by_code.paginate(:all, :page => params[:page], :per_page => journals_per_page) || []
    @journal_count = Journal.for_parent(@group).count
    @users = @group.users
    @user_count = @users.count
    @users = WillPaginate::Collection.create(1, 10000) do |pager|
       pager.replace(@users)
     end

     respond_to do |format|
       format.html
       format.js {
         render :update do |page|
           page.replace_html 'journals', :partial => 'journals/journals'
         end
       }
     end

  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'Du har ikke adgang til dette team.'
    redirect_to teams_url
  end

  # Displays a form to create a new group. Posts to the #create action.
  def new
    # if team is created from Center.show, then center is set to parent
    @groups = []
    if params[:id]  # center id is parameter
      @groups += Group.all(:conditions => [ 'id = ?', params[:id] ])
    else
      @groups = current_user.centers # + current_user.center  # teams can only be subgroup of center, not of teams
      @groups.compact.uniq  # if superadmin, center is nil
    end

    @group = Team.new(params && params[:group] || {})
    @group.parent = @groups.first if @groups.size == 1
    # set suggested team code if only one center possible
    @group.code = @groups.first.next_team_code if @groups.size == 1 # for superadmin, no code is set
  end

  def create
    @group = Team.new(params[:group])
    if !params[:group][:parent]
      flash[:error] = 'Du skal vælge et center'
      render teams_url
    else
      @center = Group.find(params[:group][:parent])
      @group.parent = @center
      @group.center = @center
    end
    
    if @group.save
      current_user.teams(true) # reload list of teams
      flash[:notice] = 'Teamet er oprettet.'
      redirect_to team_url(@group)
    else
      if params[:group][:code].include? "-"
        flash[:error] = "Kode skal være uden centerkode: #{params[:group][:code]}"
      end
      @groups = current_user.centers || Center.find(:all)  # last is for superadmins
      redirect_to new_team_in_center_url(@group, params)
    end
      
  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'You sent an invalid request.'
    #render_text "group parms: " + params.inspect
    redirect_to teams_url
  end

  def edit
    @group = Team.find(params[:id])
    @groups = if current_user.center
      [current_user.center]
    else
      current_user.centers
    end
    
  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'Teamet kunne ikke findes.'
    redirect_to teams_url
  end

  def update
    @groups = current_user.center
    @group = Team.find(params[:id])
    # get an array of roles and set the role associations
    # params[:group][:roles] = [] if params[:group][:roles].nil?
    # roles = params[:group][:roles].collect { |i| Role.find(i) }
    # @group.roles = roles

    # set parent manually
    # @group.parent = params[:group][:parent].blank? && nil || Center.find(params[:group][:parent])

    # Bulk-Assign the other attributes from the form.
    if @group.update_attributes(params[:group])
      flash[:notice] = 'Teamet er opdateret.'
      redirect_to team_url(@group) and return
    else
      flash[:error] = 'Teamet kunne ikke opdateres.'
      render edit_team_url(@group) and return
    end

  # rescue RecursionInTree
  #   @role.errors.add :parent, "must not be a descendant of itself"
  #   render edit_team_url(@group)
  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'You sent an invalid request.'
    redirect_to teams_url
  end

  # Displays a "Do you really want to delete it?" form. 
  def delete
    @group = Team.find(params[:id])

  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'Teamet kunne ikke findes.'
    redirect_to teams_url
  end

  # If the answer to the form in #delete has not been "Yes", it 
  # redirects to the #show action with the selected's group's ID.
  # Any children are moved to the parent of this group
  def destroy
    @group = Team.find(params[:id])
    if not params[:yes].nil?
      if @group.journals.any?
        @group.journals.each { |journal| journal.parent = @group.parent; journal.save }
      end
      @group.destroy
      flash[:notice] = 'Teamet er slettet.'
      redirect_to teams_url
    else
      flash[:notice] = 'Teamet blev ikke slettet.'
      redirect_to team_url(@group)
    end

  rescue CantDeleteWithChildren
    flash[:error] = "You have to delete or move the team's children before attempting to delete the group itself."
    redirect_to team_url(@group)
  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'Teamet kunne ikke findes.'
    redirect_to teams_url
  end
  
  def center
    @group = Center.find params[:center_id]
    @teams = @group.teams
    
    respond_to do |format|
      format.html {
         redirect_to team_path(@group) and return if @group.instance_of?(Team) }
      format.rjs {
        render :update do |page|
          page.replace_html 'teams_content', :partial => 'center'
        end
      }
    end
  end

  def select_move_journals # nb. :id is Team id!
    @group = Team.find(params[:id])
    @page_title = "CBCL - Center " + @group.parent.title + ", team " + @group.title
    @groups = Journal.for_parent(@group).by_code.paginate(:all, :page => params[:page], :per_page => journals_per_page*2, :order => 'title') || []
    @teams = current_user.teams
    @journal_count = Journal.for_parent(@group).count

     respond_to do |format|
       format.html { render "select" }
       format.js { render :update do |page| page.replace_html 'journals', :partial => 'shared/select_journals' end }
     end

  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'Du har ikke adgang til dette team.'
    redirect_to teams_url
  end

  def move_journals
    team = Team.find(params[:id])
    flash[:error] = 'Ingen journaler er valgt' if params[:journals].blank?
    redirect_to team if flash[:error]
    
    dest_team = Team.find params[:team]
    journals = Journal.find(params[:journals])
    journals.each { |journal| journal.parent = dest_team; journal.save }

    flash[:notice] = "Journaler er flyttet fra #{team.title} til team #{dest_team.title}"
    redirect_to select_journals_path(team) and return
  end

  protected
  before_filter :behandler_access, :only => [ :list, :index, :show ]
  # before_filter :teamadmin_access, :only => [ :edit ]
  before_filter :centerleder_access, :except => [ :list, :index, :show, :center ]
  before_filter :check_access, :except => [:index, :list, :per_page, :center]
  
  def behandler_access
    if !current_user
      flash[:notice] = "Du har ikke adgang til denne side"
      redirect_to login_path
    end
  end

  # def teamadmin_access
  #   if current_user.access? :team_edit
  #     return true
  #   elsif current_user
  #     flash[:notice] = "Du har ikke adgang til denne side"
  #     redirect_to teams_path
  #   else
  #     flash[:notice] = "Du har ikke adgang til denne side"
  #     redirect_to login_path
  #   end
  # end
  
  def centerleder_access
    if current_user.access? :team_new_edit_delete
      return true
    elsif current_user
      puts "centerleder_access current_user: #{current_user.inspect}"
      flash[:notice] = "Du har ikke adgang til denne side"
      redirect_to teams_path
    else
      puts "centerleder_access NOT LOGGED IN"
      flash[:notice] = "Du har ikke adgang til denne side"
      redirect_to login_path
    end
  end
  
  def check_access
    check_logged_in
    if params[:id] && current_user && current_user.access?(:all_users)
      access = current_user.team_member? params[:id].to_i
    elsif !params[:id] && current_user.access?(:login_user)
      true
    end
  end
  
end