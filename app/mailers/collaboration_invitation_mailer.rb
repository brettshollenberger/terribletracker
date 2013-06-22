class CollaborationInvitationMailer < ActionMailer::Base
  default from: "brett.shollenberger@gmail.com", host: "http://0.0.0.0:3000"

  def collaboration_invitation_email(user, project)
    @base_url = "http://0.0.0.0:3000"
    @user = user
    @project = project
    @membership = Membership.where(user_id: @user, project_id: @project).first
    @inviter = @membership.inviter
    @url = "#{@base_url}/projects/#{@project.id}"
    @accept_url = "http://0.0.0.0:3000/membership/#{@membership.id}/accept"
    mail(:to => "#{@user.email}", :subject => "You've been invited to #{@project.title} on Terrible Tracker")
  end
end
