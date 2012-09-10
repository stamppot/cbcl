# encoding: utf-8

class ProjectsController < ApplicationController

	def index
		@projects = Project.all #find_all_by_center_id(current_user.center_id)
	end


	def show
		@project = Project.find(params[:id])
		return false unless current_user.centers.include?(@project.center)
		@journals = @project.journals.paginate(:all, :page => params[:page], :per_page => 20)
		@group = @project.center
	end

	def new
		@centers = current_user.centers
		@center = @centers.first
		@project = Project.new(:center => @center)
	end

	def create
		@project = Project.new(params[:project])
		@project.center_id = @center

		if @project.save
			flash[:notice] = "Projektet er oprettet"
			redirect_to(@project)
		else
			render :new, :params => params and return
		end
	end

	def edit
		@centers = current_user.centers
		@center = @centers.first
		@project = Project.find(params[:id])
	end

	def update
		@project = Project.find(params[:id])

		if @project.update_attributes(params[:project])
      		flash[:notice] = 'Projektet er rettet.'
      		redirect_to(@letter) and return
    	else
	      render :edit
    	end
	end

	def delete
	end

	def destroy
      @project = Project.find(params[:id])
      # return if project.journals.any?
      @project.destroy
      flash[:notice] = "Projektet #{@project.name} er blevet slettet."
      redirect_to projects_path
	end

	def remove
	  @project = Project.find(params[:id])
	  journal = Journal.find(params[:journal_id])
	  @project.journals.delete(journal)
      flash[:notice] = "Journalen #{journal.title} er blevet fjernet fra projektet."
      redirect_to project_path(@project)		
	end

  def export_journals
    project = Project.find(params[:id])
    
    # TODO: get journal_entries for parent surveys
    journal_entries = 
    project.journals.inject([]) do |col, journal|
    	parent_entries = journal.journal_entries.select {|entry| entry.not_answered? && entry.login_user && entry.is_parent_survey? }
    	col << parent_entries
    	col
    end.flatten

    respond_to do |wants|
      wants.html {
        # @login_users = team.journals.map { |journal| journal.journal_entries }.flatten.map {|entry| entry.login_user}.compact
        csv = CSVHelper.new.mail_merge_login_users(journal_entries)
        
        send_data(csv, :filename => Time.now.strftime("%Y%m%d%H%M%S") + "_logins_projekt_#{project.code.underscore}.csv", 
                  :type => 'text/csv', :disposition => 'attachment')

      }
      wants.csv {
        csv = CSVHelper.new.mail_merge_login_users(journal_entries)
        
        send_data(csv, :filename => Time.now.strftime("%Y%m%d%H%M%S") + "_logins_projekt_#{project.code.underscore}.csv", 
                  :type => 'text/csv', :disposition => 'attachment')
      }
    end
  end

  def select
    @project = Project.find(params[:id])
    @group = @project.center
    @page_title = "CBCL - Center " + @group.title
    @groups = Journal.for_center(@group).by_code.and_person_info.paginate(:all, :page => params[:page], :per_page => journals_per_page*2, :order => 'title') || []
    @groups = @groups.reject { |journal| @project.journals.include?(journal) }

    @journal_count = Journal.for_center(@group).count

     respond_to do |format|
       format.html
       format.js {
         render :update do |page|
           page.replace_html 'journals', :partial => 'project/select_project_journals'
         end
       }
     end

  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'Du har ikke adgang til dette center.'
    redirect_to teams_url
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
end