class TeamsController < ApplicationController
  before_filter :authenticate_user!

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
      track_activity(@team)
      @activity = find_activity
      session[:checked] = @team.id

      respond_to do |format|
        format.html
        format.js
      end
    else
      errorize
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
      session[:checked] = @team.id
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

  def deactivate
    @checked = session[:checked]
    @team = Team.find(params[:id])
    @id = @team.id
    @team.deactivate
    track_activity(@team)
    Membership.where(joinable_id: @team.id, joinable_type: "Team").all.each { |m| m.deactivate }
    @activities = current_user.recent_activities
    render "deactivate", :formats => [:js]
  end

  def activate
    @team = Team.find(params[:id])
    @team.activate
    Membership.where(joinable_id: @team.id, joinable_type: "Team").all.each { |m| m.activate }
    @activities = @team.activities
    @projects = @team.projects.order("created_at")
    @project = @team.projects.new
    @users = UserDecorator.decorate_collection(@team.members)
    @checked = session[:checked]
    track_activity(@team)
    session[:checked] = @team.id
    render "activate", :formats => [:js]
  end

  def destroy
    Membership.where(joinable_id: @team.id, joinable_type: "Team").all.each { |m| m.destroy }
    @team.projects.each do |project|
      project.memberships.each { |m| m.destroy }
    end
    @team.destroy
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
    Activity.where(team_id: @team.id).order("created_at DESC").last
  end

  def errorize
    if @team.errors[:name].include?("has already been taken")
      @team_errors = "You already have a team by that name."
    elsif @team.errors[:name].include?("can't be blank")
      @team_errors = "You must name your team."
    end
  end

end
