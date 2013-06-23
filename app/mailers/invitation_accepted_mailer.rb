class InvitationAcceptedMailer < ActionMailer::Base
  default from: "brett.shollenberger@gmail.com", host: "http://0.0.0.0:3000"

  def invitation_accepted_email_owner(user, project)
    @base_url = "http://0.0.0.0:3000"
    @user = user
    @project = project
    @membership = Membership.where(user_id: @user.id, joinable_id: @project.id, joinable_type: "Project").first
    @inviter = @membership.inviter
    @owner = @project.owner
    @url = "#{@base_url}/projects/#{@project.id}"
    mail(:to => "#{@owner.email}",
      :subject => "#{@user.first_name} joined #{@project.title}")
  end

  def invitation_accepted_email_inviter(user, project)
    @base_url = "http://0.0.0.0:3000"
    @user = user
    @project = project
    @membership = Membership.where(user_id: @user.id, joinable_id: @project.id, joinable_type: "Project").first
    @inviter = @membership.inviter
    @owner = @project.owner
    @url = "#{@base_url}/projects/#{@project.id}"
    mail(:to => "#{@inviter.email}",
      :subject => "#{@user.first_name} joined #{@project.title}")
  end

  def team_invitation_accepted_email_owner(user, team)
    @base_url = "http://0.0.0.0:3000"
    @user = user
    @team = team
    @membership = Membership.where(user_id: @user.id, joinable_id: @team.id, joinable_type: "Team").first
    @inviter = @membership.inviter
    @owner = @team.owner
    @url = "#{@base_url}/teams/#{@team.id}"
    mail(:to => "#{@owner.email}",
      :subject => "#{@user.first_name} joined #{@team.name}")
  end

  def team_invitation_accepted_email_inviter(user, team)
    @base_url = "http://0.0.0.0:3000"
    @user = user
    @team = team
    @membership = Membership.where(user_id: @user.id, joinable_id: @team.id, joinable_type: "Team").first
    @inviter = @membership.inviter
    @owner = @team.owner
    @url = "#{@base_url}/projects/#{@team.id}"
    mail(:to => "#{@inviter.email}",
      :subject => "#{@user.first_name} joined #{@team.name}")
  end

end
