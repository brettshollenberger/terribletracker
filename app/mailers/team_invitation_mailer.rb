class TeamInvitationMailer < ActionMailer::Base
  default from: "brett.shollenberger@gmail.com", host: "heroku.com"

  def team_invitation_email(user, team)
    @base_url = "http://terribletracker-staging.herokuapp.com"
    @user = user
    @team = team
    @membership = Membership.where(user_id: @user, joinable_id: @team.id, joinable_type: "Team").first
    @inviter = @membership.inviter
    @url = "#{@base_url}/teams/#{@team.id}"
    @accept_url = "http://0.0.0.0:3000/membership/#{@membership.id}/accept_team"
    mail(:to => "#{@user.email}", :subject => "You've been invited to #{@team.name} on Terrible Tracker")
  end
end
