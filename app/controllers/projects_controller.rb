class ProjectsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @user = current_user
    @team = Team.new
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
    @team = Team.find(params[:team])

    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @team = Team.find(params[:project][:team_id])
    @project = Project.new(params[:project])
    @user_stories = UserStoryDecorator.decorate_collection(@project.user_stories.order("created_at"))
    @user_story = UserStory.new
    @users = UserDecorator.decorate_collection(@project.users)

    if @project.save
      @membership = Membership.new(joinable: @project, user: current_user, role: "owner", state: "active")

      if @membership.save
        respond_to do |format|
          format.html { redirect_to @project }
          format.js
        end
      else
        respond_to do |format|
          format.html { redirect_to new_project_path }
          format.js   { "new" }
        end
      end
    end
  end

  def edit
    @project = Project.find(params[:id])
  end

  def update
    @project = Project.find(params[:id])
    @team = @project.team
    @user_stories = UserStoryDecorator.decorate_collection(@project.user_stories.order("created_at"))
    @user_story = UserStory.new
    @users = UserDecorator.decorate_collection(@project.users)
    if @project.update_attributes(params[:project])
      respond_to do |format|
        format.html
        format.js
      end
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
