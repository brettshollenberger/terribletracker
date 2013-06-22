class ProjectsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @user = current_user
    @projects, @invitations = find_projects
  end

  def show
    @project = current_user.projects.find(params[:id])
    @user_stories = UserStoryDecorator.decorate_collection(@project.user_stories.order("created_at"))
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(params[:project])

    if @project.save
      @membership = Membership.new(project: @project, user: current_user, role: "owner", state: "active")

      if @membership.save
        flash[:notice] = "Project created successfully"
        redirect_to @project
      end
    else
      flash[:error] = "Oops. There was an error creating your project!"
      redirect_to new_project_path
    end
  end

  def edit
    @project = Project.find(params[:id])
  end

  def update
    @project = Project.find(params[:id])

    if @project.update_attributes(params[:project])
      flash[:notice] = "Project updated!"
      redirect_to @project
    else
      flash[:error] = "There was an error updating your project!"
      redirect_to edit_project_path(@project)
    end
  end

  def destroy
    @project = Project.find(params[:id])

    if @project.destroy
      flash[:notice] = "Project deleted"
      redirect_to projects_path
    else
      flash[:error] = "Oops. There was an error deleting your project"
      redirect_to projects_path
    end
  end

  def find_projects
    active_projects_list = []
    invitations = []
    current_user.memberships.each do |membership|
      active_projects_list.push(membership.project) if membership.state == "active"
      invitations.push(membership) if membership.state == "pending"
    end
    return active_projects_list, MembershipDecorator.decorate_collection(invitations)
  end

end
