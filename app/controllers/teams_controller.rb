class TeamsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @team = current_user.teams
  end

  def new
    @team = Team.new
  end

  def create
    @team = Team.new(params[:team])
    @team.owner_id = current_user.id

    if @team.save
      @membership = Membership.new(joinable: @team, user: current_user, role: "owner", state: "active")

      if @membership.save
        flash[:notice] = "Team created successfully"
        redirect_to @team
      end
    else
      flash[:error] = "Oops. There was an error creating your team!"
      redirect_to new_team_path
    end
  end

  def show
    @team = Team.find(params[:id])
  end

  def show_projects
    @team = Team.find(params[:id])

    if params[:checked] == "1"
      hide_projects
    else

      respond_to do |format|
        format.html { redirect_to root_path }
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
    @project = Project.find(params[:id])
    @team = @project.team
    @user_stories = UserStoryDecorator.decorate_collection(@project.user_stories.order("created_at"))
    @user_story = UserStory.new

    respond_to do |format|
      format.html { redirect_to project_path(@project) }
      format.js
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
