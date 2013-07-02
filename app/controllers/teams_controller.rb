class TeamsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @team = current_user.teams
  end

  def new
    @team = Team.new
    @checked = params[:checked].to_i if params[:checked]

    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @team = Team.new(params[:team])
    @team.owner_id = current_user.id
    @project = @team.projects.new

    if @team.save
      @membership = Membership.new(joinable_id: @team.id, joinable_type: "Team", user: current_user, role: "owner", state: "active")
      @membership.save
      @users = UserDecorator.decorate_collection(@team.members)

      respond_to do |format|
        format.html
        format.js
      end
    else
      render "new.js"
    end
  end

  def show
    @checked = params[:checked].to_i if params[:checked]
    @team = Team.find(params[:id])
    @projects = @team.projects.order("created_at")
    @project = @team.projects.new
    @users = UserDecorator.decorate_collection(@team.members)
    @activities = @team.activities

    if @team.id == @checked
      hide_projects
    else
      respond_to do |format|
        format.html { redirect_to root_path }
        format.js
      end
    end
  end

  def update
    @team = Team.find(params[:id])
    @users = UserDecorator.decorate_collection(@team.members)
    if @team.update_attributes(params[:team])
      respond_to do |format|
        format.html
        format.js
      end
    end
  end

  def hide_projects
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js { render "hide_projects" }
    end
  end

  def show_project
    @checked_project = params[:checked].to_i if params[:checked]
    @project = Project.find(params[:id])
    @team = @project.team
    @user_stories = UserStoryDecorator.decorate_collection(@project.user_stories.order("position"))
    @user_story = UserStory.new
    @users = UserDecorator.decorate_collection(@project.users)

    if @project.id == @checked_project
      hide_project
    else
      respond_to do |format|
        format.html { redirect_to project_path(@project) }
        format.js
      end
    end
  end

  def hide_project
    @team = @project.team
    @activities = @team.activities
    @project = Project.new

    respond_to do |format|
      format.html { redirect_to team_path(@team) }
      format.js { render "hide_project" }
    end
  end

private

  def find_team
    params.each do |name, value|
      if name =~ /^project_(.+)/
        return $1
      end
    end
  end

  def find_project
    params.each do |name, value|
      if name =~ /^project_(.+)/
        return $1
      end
    end
  end

end
