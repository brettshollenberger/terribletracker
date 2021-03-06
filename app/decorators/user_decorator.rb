class UserDecorator < Draper::Decorator
  delegate_all

  def active_teams
    teams = []
    self.active_team_memberships.each do |membership|
      teams.push(membership.joinable) if membership.joinable.state == "active"
    end
    teams
  end

  def inactive_teams
    teams = []
    self.teams.inactive.all.each { |team| teams.push(team) }
    teams
  end

  def team_invitations
    invitation_list = []
    self.pending_team_memberships.each do |membership|
      invitation_list.push(membership) if membership.joinable.state == "active"
    end
    MembershipDecorator.decorate_collection(invitation_list)
  end

  def gravatar
    gravatar_id = Digest::MD5.hexdigest(self.email.downcase)
    h.link_to("https://en.gravatar.com/emails/") do
      h.image_tag "http://gravatar.com/avatar/#{gravatar_id}.png?s=150"
    end
  end

  def gravatar_small
    gravatar_id = Digest::MD5.hexdigest(self.email.downcase)
    h.image_tag "http://gravatar.com/avatar/#{gravatar_id}.png?s=150"
  end

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

end
