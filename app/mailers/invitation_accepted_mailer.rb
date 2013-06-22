class InvitationAcceptedMailer < ActionMailer::Base
  default from: "brett.shollenberger@gmail.com", host: "http://0.0.0.0:3000"

  def invitation_accepted_email_owner(user, project)
    @base_url = "http://0.0.0.0:3000"
    @user = user
    @project = project
    @membership = Membership.where(user_id: @user, project_id: @project).first
    @inviter = @membership.inviter
    @owner = @membership.project.owner
    @url = "#{@base_url}/projects/#{@project.id}"
    mail(:to => "#{@owner.email}",
      :subject => "#{@user.first_name} joined #{@project.title}")
  end

  def invitation_accepted_email_inviter(user, project)
    @base_url = "http://0.0.0.0:3000"
    @user = user
    @project = project
    @membership = Membership.where(user_id: @user, project_id: @project).first
    @inviter = @membership.inviter
    @owner = @membership.project.owner
    @url = "#{@base_url}/projects/#{@project.id}"
    mail(:to => "#{@inviter.email}",
      :subject => "#{@user.first_name} joined #{@project.title}")
  end

end
