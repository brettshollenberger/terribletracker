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
      track_team_activity(@team, team=@team)
      @activity = find_activity

      respond_to do |format|
        format.html
        format.js
      end
    else
      @team_errors = "You cannot have two teams with the same name"
      render "team_errors", :formats => [:js]
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

  def find_activity
    Activity.where(team_id: @team.id).order("created_at DESC").first
  end

end
