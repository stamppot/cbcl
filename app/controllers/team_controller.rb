# This is the controller that provides CRUD functionality for the Center model.
class TeamController < ApplicationController # < ActiveRbac::ComponentController
  # The RbacHelper allows us to render +acts_as_tree+ AR elegantly
  helper RbacHelper
  
  # We force users to use POST on the state changing actions.
  verify :method       => "post",
         :only         => [ :create, :update, :destroy ],
         :redirect_to  => { :action => :list },
         :add_flash    => { :error => 'You sent an invalid request!' }
          
  # We force users to use GET on all other methods, though.
  verify :method       => :get,
         :only         => [ :index, :list, :show, :new, :delete ],
         :redirect_to  => { :action => :list },
         :add_flash    => { :error => 'You sent an invalid request!' }

  # Simply redirects to #list
  def index
    redirect_to :action => :list
  end

  def login_users
    @team = Team.find(params[:id])
    
    respond_to do |wants|
      wants.html {
        @users = @team.children.map { |journal| journal.journal_entries }.flatten.map {|entry| entry.login_user}.compact
        @users = WillPaginate::Collection.create(1, @users.size + 1) do |pager|
             # inject the result array into the paginated collection:
             pager.replace(@users)
        	 end
      }
      wants.csv {
        csv = CSVHelper.new.login_users(@team.children)
        
        send_data(csv, :filename => Time.now.strftime("%Y%m%d") + "_login_brugere_team_#{@team.title.underscore}.csv", 
                  :type => 'text/csv', :disposition => 'attachment')
      }
    end
  end

  # problem: does not reload when adding new team!!!
  # Displays a tree of all projects.
  def list
    @page_title = "CBCL - Liste af teams"
    @groups = current_user.teams.group_by { |team| team.center }
  end

  # Show a group identified by the +:id+ path fragment in the URL.
  def show
    @group = Team.find(params[:id])
    @page_title = "CBCL - Center " + @group.parent.title + ", team " + @group.title
    @groups = Journal.paginate(:all, :page => params[:page], :per_page => 15, :conditions => ['parent_id = ?', @group], :order => 'code ASC') || []
    
    if @group.kind_of?(Center)
      redirect_to :controller => 'center', :action => :show, :id => @group
    end

  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'Du har ikke adgang til dette team.'
    redirect_to :action => :list
  end

  # Displays a form to create a new group. Posts to the #create action.
  def new
    # if team is created from Center.show, then center is set to parent
    @groups = []
    if params[:id]  # center id is parameter
      @groups += Group.find :all, :conditions => [ 'id = ?', params[:id] ]
    else
      @groups = [] << current_user.center  # teams can only be subgroup of center, not of teams
      @groups.compact!  # if superadmin, center is nil
    end

    @group = Team.new
    @group.parent = @groups.first if @groups.size == 1
    # set suggested team code
    @groups = if current_user.center
      [current_user.center]
    else
      current_user.centers
    end
    @group.code = @groups.first.next_team_id if @groups.size == 1 # for superadmin, no code is set
  end

  # Creates a new group. +create+ is only accessible via POST and renders
  # the same form as #new on validation errors.
  def create
    @group = Team.new(params[:group])
    if params[:group][:parent].nil?
      flash[:error] = 'Du skal vælge et center'
      render :action => :list
    else
      @center = Group.find(params[:group][:parent]) # unless params[:group][:parent].nil?
      @group.parent = @center
      @group.center = @center
    end
    
    if @group.save
      current_user.teams(true) # reload list of teams
      flash[:notice] = 'Teamet er oprettet.'
      redirect_to :action => :show, :id => @group
    else
      @groups = current_user.centers || Center.find(:all)  # last is for superadmins
      render :action => :new, :id => @group
    end
      
  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'You sent an invalid request.'
    #render_text "group parms: " + params.inspect
    redirect_to :action => :list
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
    redirect_to :action => :list
  end

  def update
    @groups = current_user.center
    @group = Team.find(params[:id])
    # get an array of roles and set the role associations
    params[:group][:roles] = [] if params[:group][:roles].nil?
    roles = params[:group][:roles].collect { |i| Role.find(i) }
    @group.roles = roles

    # set parent manually
    @group.parent = params[:group][:parent].blank? && nil || Center.find(params[:group][:parent])

    # Bulk-Assign the other attributes from the form.
    if @group.update_attributes(params[:group])
      flash[:notice] = 'Teamet er opdateret.'
      redirect_to :action => :show, :id => @group.to_param and return
    else
      render :action => :edit and return
    end

  rescue RecursionInTree
    @role.errors.add :parent, "must not be a descendant of itself"
    render :action => :edit
  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'You sent an invalid request.'
    redirect_to :action => :list
  end

  # Loads the group specified by the :id parameters from the url fragment from
  # the database and displays a "Do you really want to delete it?" form. It
  # posts to #destroy.
  def delete
    @group = Team.find(params[:id])

  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'Teamet kunne ikke findes.'
    redirect_to :action => :list
  end

  # Removes a group record from the database. +destroy+ is only accessible
  # via POST. If the answer to the form in #delete has not been "Yes", it 
  # redirects to the #show action with the selected's group's ID.
  # Any children are moved to the parent of this group
  def destroy
    if not params[:yes].nil?
      @group = Team.find(params[:id])
      if @group.children.size > 0
        @group.children.each { |journal| journal.parent = @group.parent; journal.save }
      end
      @group.destroy
      flash[:notice] = 'Teamet er slettet.'
      redirect_to :action => :list
    else
      flash[:notice] = 'Teamet blev ikke slettet.'
      redirect_to :action => :show, :id => params[:id]
    end

  rescue CantDeleteWithChildren
    flash[:error] = "You have to delete or move the team's children before attempting to delete the group itself."
    redirect_to :action => :show, :id => params[:id]
  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'Teamet kunne ikke findes.'
    redirect_to :action => :list
  end
  
  protected
  before_filter :behandler_access, :only => [ :list, :index, :show ]
  before_filter :centerleder_access, :except => [ :list, :index, :show ]
  before_filter :check_access, :except => [:index, :list, :per_page]
  
  def behandler_access
    if session[:rbac_user_id] and current_user.has_access? :all_users
      return true
    elsif current_user
      redirect_to "/login"
      flash[:notice] = "Du har ikke adgang til denne side"
      return false
    else
      redirect_to "/login"
      flash[:notice] = "Du har ikke adgang til denne side"
      return false
    end
  end

  def centerleder_access
    if session[:rbac_user_id] and current_user.has_access? :team_new_edit_delete
      return true
    elsif current_user
      redirect_to "/team/list"
      flash[:notice] = "Du har ikke adgang til denne side"
      return false
    else
      redirect_to "/login"
      flash[:notice] = "Du har ikke adgang til denne side"
      return false
    end
  end
  
  def check_access
    if params[:id] and current_user and (current_user.has_access?(:all_users) || current_user.has_access?(:login_user))
      access = current_user.team_member? params[:id].to_i
    elsif !params[:id]
      true
    end
  end
  
  
end