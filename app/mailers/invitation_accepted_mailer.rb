class InvitationAcceptedMailer < ActionMailer::Base
  default from: "brett.shollenberger@gmail.com", host: "heroku.com"

  def team_invitation_accepted_email_owner(user, team)
    @base_url = "http://terribletracker-staging.herokuapp.com"
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
    @base_url = "http://terribletracker-staging.herokuapp.com"
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
