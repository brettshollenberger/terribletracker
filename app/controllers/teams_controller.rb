class TeamsController < ApplicationController

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

end
