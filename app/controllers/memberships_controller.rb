class MembershipsController < ApplicationController

  def new
    @project = Project.find(params[:project])
    @role = params[:role] || "collaborator"
    @membership = Membership.new
  end

  def create
    @project = Project.find(params[:membership][:project])
    @user = User.where(email: params[:membership][:user]).first
    @role = params[:membership][:role]
    @membership = Membership.new(user: @user, joinable: @project, role: @role, inviter_id: current_user.id)

    if @membership.save
      CollaborationInvitationMailer.collaboration_invitation_email(@user, @project).deliver
      if @membership.role == "collaborator"
        flash[:notice] = "Collaborator Added"
      else
        flash[:notice] = "Client Added"
      end
      redirect_to @project
    else
      if @membership.errors.include?(:user)
        flash[:notice] = "#{params[:membership][:user]} is not yet on Terrible Tracker."
      elsif @membership.errors.include?(:user_id) &&
        Membership.where(user_id: @user.id).first.state == "active"
        flash[:notice] = "#{params[:membership][:user]} is already active on this project."
      elsif @membership.errors.include?(:user_id)
        flash[:notice] = "#{params[:membership][:user]} has already been invited to this project"
      else
        flash[:notice] = "There was an error adding #{params[:membership][:user]} as a collaborator."
      end
      redirect_to new_membership_path(project: @project.id)
    end
  end

  def destroy
    @membership = Membership.find(params[:id])
    @joinable = @membership.joinable
    if @membership.delete
      flash[:notice] = "Member removed"
    else
      flash[:notice] = "There was an error removing this member."
    end
    redirect_to @joinable
  end

  def accept
    @membership = Membership.find(params[:id])
    if @membership.approve_membership
      if current_user != @membership.user
        redirect_to logout_path
      else
        flash[:notice] = "You're a #{@membership.role}!"
        redirect_to @membership.joinable
      end
    else
      redirect_to root_path
    end
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
    redirect_to root_path
  end

  def new_team_membership
    @team = Team.find(params[:team])
    @membership = Membership.new
  end

  def create_team_membership
    @team = Team.find(params[:membership][:team])
    @user = User.where(email: params[:membership][:user]).first
    @membership = Membership.new(user: @user, joinable: @team, inviter_id: current_user.id)

    if @membership.save
      TeamInvitationMailer.team_invitation_email(@user, @team).deliver
      flash[:notice] = "Member invited"
    else
      flash[:notice] = "There was an error inviting this member"
    end
    redirect_to new_team_membership_path(team: @team)
  end

  def accept_team
    @membership = Membership.find(params[:id])
    if @membership.approve_membership
      @membership.team.projects.each do |project|
        Membership.create(joinable: project, user: @membership.user, role: "collaborator", state: "active")
      end
      if current_user != @membership.user
        redirect_to logout_path
      else
        flash[:notice] = "You're a #{@membership.role}!"
        redirect_to @membership.team
      end
    else
      redirect_to root_path
    end
  end

end
