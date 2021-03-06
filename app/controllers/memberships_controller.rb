class MembershipsController < ApplicationController
  before_filter :authenticate_user!

  def new
    @team = Team.find(params[:team])
    @membership = Membership.new
    render "new", :formats => [:js]
  end

  def create
    @team = Team.find(params[:membership][:team])
    @user = User.where(email: params[:membership][:user]).first
    @membership = Membership.new(user: @user, joinable_id: @team.id, joinable_type: "Team", inviter: current_user)

    if @membership.save
      TeamInvitationMailer.team_invitation_email(@user, @team).deliver
      flash[:notice] = "Member invited"
    else
      flash[:notice] = "There was an error inviting this member"
    end
    render "create", :formats => [:js]
  end

  def destroy
    @membership = Membership.find(params[:id])
    @user = @membership.user
    @team = @membership.joinable
    if @membership.delete
      @team.projects.each do |project|
        begin
          destroy_project_memberships(project)
          remove_user_from_team_project(project)
        rescue
          next
        end
      end
    end
    render "destroy", :formats => [:js]
  end

  def accept
    @membership = Membership.find(params[:id])
    @team = @membership.joinable
    @users = UserDecorator.decorate_collection(@team.members)
    @project = @team.projects.new
    if @membership.approve_membership
      @membership.team.projects.each do |project|
        Membership.create(joinable: project, user: @membership.user, role: "collaborator", state: "active")
      end
    end
    render "accept", :formats => [:js]
  end

  def decline
    @membership = Membership.find(params[:id])
    if @membership.delete
      if current_user != @membership.user
        redirect_to logout_path
      else
        flash[:notice] = "You've declined."
      end
    end
    render "/projects/homepage", :formats => [:js]
  end

private

  def destroy_project_memberships(project)
    @user.memberships.where(joinable_id: project.id, joinable_type: "Project").first.destroy
  end

  def remove_user_from_team_project(project)
    project.user_stories.each do |user_story|
      if user_story.user_id == @user.id
        user_story.user_id = nil
        user_story.save
      end
    end
  end
end
