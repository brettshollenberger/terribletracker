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
    @membership = Membership.new(user: @user, project: @project, role: @role)

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

end
