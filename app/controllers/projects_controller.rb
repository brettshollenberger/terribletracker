class ProjectsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @activities = current_user.recent_activities.page(params[:page]).per(10)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @checked_project = params[:checked].to_i if params[:checked]
    @project = Project.find(params[:id])
    @team = @project.team
    @user_stories = UserStoryDecorator.decorate_collection(@project.user_stories.order("position"))
    @user_story = UserStory.new
    @users = UserDecorator.decorate_collection(@project.users)
    @activities = @project.activities.page(params[:page]).per(5)

    if @project.id == @checked_project
      hide
    else
      session[:checked_project] = @project.id
      render "show", :formats => [:js]
    end
  end

  def hide
    @team = @project.team
    @activities = @team.activities.page(params[:page]).per(5)
    @old_project = @project
    @project = Project.new

    render "hide", :formats => [:js]
  end

  def new
    @team = Team.find(params[:team])
    @project = @team.projects.new

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

    if @project.save
      create_memberships
      track_activity(@project)
      @activities = @project.activities.page(params[:page]).per(5)
      session[:checked_project] = @project.id
    else
      @project_error = "Please give your project a new name."
      render "new", :formats => [:js]
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
    @project.update_attributes(params[:project])
    render "update", :formats => [:js]
  end

  def deactivate
    @checked_project = session[:checked_project]
    @project = Project.find(params[:id])
    @id = @project.id
    @project.deactivate
    track_activity(@project)
    Membership.where(joinable_id: @project.id, joinable_type: "Project").all.each { |m| m.deactivate }
    @activities = current_user.recent_activities.page(params[:page]).per(10)
    render "deactivate", :formats => [:js]
  end

  def activate
    @project = current_user.projects.find(params[:id])
    @project.activate
    Membership.where(joinable_id: @project.id, joinable_type: "Project").all.each { |m| m.activate }
    @activities = @project.activities
    @users = UserDecorator.decorate_collection(@project.users)
    @checked_project = session[:checked_project]
    track_activity(@project)
    @team = @project.team
    @user_stories = UserStoryDecorator.decorate_collection(@project.user_stories.order("position"))
    @user_story = UserStory.new
    session[:checked_project] = @project.id
    render "activate", :formats => [:js]
  end

  def destroy
    @checked_project = session[:checked_project]
    @project = Project.find(params[:id])
    @id = @project.id
    @project.destroy
    @activities = current_user.recent_activities.page(params[:page]).per(10)
    Membership.where(joinable_id: @project.id, joinable_type: "Project").all.each { |m| m.destroy }
    render "destroy", :formats => [:js]
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

  def homepage
    @user = current_user
    @activities = current_user.recent_activities.page(params[:page]).per(10)
    @team = Team.new
    respond_to do |format|
      format.html
      format.js
    end
  end

private
  def create_memberships
    @membership = Membership.new(joinable: @project, user: current_user, role: "owner", state: "active")
    @membership.save
    @team.members.each { |member| Membership.create(joinable: @project, user: member, role: "collaborator", state: "active") }
    @users = UserDecorator.decorate_collection(@project.users)
  end

end
