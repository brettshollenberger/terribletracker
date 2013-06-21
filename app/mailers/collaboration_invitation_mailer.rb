class CollaborationInvitationMailer < ActionMailer::Base
  default from: "brett.shollenberger@gmail.com", host: "http://0.0.0.0:3000"

  def collaboration_invitation_email(user, project)
    @user = user
    @project = project
    @url = "http://0.0.0.0:3000/projects/#{@project.id}"
    mail(:to => "#{@user.first_name} #{@user.last_name}, #{@user.email}", :subject => "You've been invited to #{@project.title}")
  end
end
