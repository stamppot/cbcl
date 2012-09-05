# encoding: utf-8

class ProjectsController < ApplicationController

	def index
		@projects = Project.all #find_all_by_center_id(current_user.center_id)
	end


	def show
		@project = Project.find(params[:id])
		return false unless current_user.centers.include?(@project.center)
		@journals = @project.journals.paginate(:all, :page => params[:page], :per_page => 20)
		@groups = @journals
		@group = @project.center
	end

	def new
		@center = current_user.admin? ? current_user.centers.first : current_user.center
		@project = Project.new(:center => @center)
	end

	def create
		@center = current_user.admin? ? current_user.centers.first : current_user.center
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
		@center = current_user.admin? ? current_user.centers.first : current_user.center
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

  def select # nb. :id is center id!
    @project = Project.find(params[:id])
    @group = @project.center
    @page_title = "CBCL - Center " + @group.title # + ", team " + @group.title
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
      project.journals << journal
    end
    project.save
    flash[:notice] = "#{journals.count} journaler er føjet til #{project.code} - #{project.name}"
    redirect_to project_path(project) #select_journals_path(team) and return
  end

end