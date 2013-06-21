class MembershipsController < ApplicationController

  def new
    @project = Project.find(params[:project])
    @membership = Membership.new
  end

  def create
    @project = Project.find(params[:membership][:project])
    @user = User.where(email: params[:membership][:user]).first
    @membership = Membership.new(user: @user, project: @project)

    if @membership.save
      flash[:notice] = "Collaborator Added"
      redirect_to @project
    else
      flash[:notice] = "User has already been invited to this project"
      redirect_to new_membership_path(project: @project.id)
    end
  end

end
