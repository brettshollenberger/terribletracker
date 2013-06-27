class ProjectsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @user = current_user
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    begin
      @project = current_user.projects.find(params[:id])
      @user_stories = UserStoryDecorator.decorate_collection(@project.user_stories.order("created_at"))
      @user_story = UserStory.new
    rescue
      redirect_to root_path
    end
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(params[:project])

    if @project.save
      @membership = Membership.new(joinable: @project, user: current_user, role: "owner", state: "active")

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

  def add_project_to_team
    @project = Project.find(params[:project])
  end

  def save_team_project_join
    @project = Project.find(params[:project][:project_id])
    @team = Team.where(name: params[:project][:team]).first

    if @project.update_attributes(team: @team)
      @team.members.each do |member|
        Membership.create(joinable: @project, user: member, role: "collaborator", state: "active")
      end
      flash[:notice] = "Project added to #{@team.name}"
      redirect_to @project
    else
      flash[:notice] = "There was an error adding this project to that team"
      redirect_to add_project_to_team_path(@project)
    end
  end

end
