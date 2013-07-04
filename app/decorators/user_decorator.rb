class UserDecorator < Draper::Decorator
  delegate_all

  def project_invitations
    invitation_list = []
    self.memberships.each do |membership|
      if membership.joinable_type == "Project"
        invitation_list.push(membership) if membership.state == "pending"
     end
    end
    invitation_list.compact!
    return MembershipDecorator.decorate_collection(invitation_list)
  end

  def active_teams
    active_teams_list = []
    self.memberships.each do |membership|
      if membership.joinable_type == "Team"
        active_teams_list.push(membership.team) if membership.state == "active"
      end
    end
    return active_teams_list
  end

  def team_invitations
    team_invitation_list = []
    self.memberships.each do |membership|
      if membership.joinable_type == "Team"
        team_invitation_list.push(membership) if membership.state == "pending"
      end
    end
    team_invitation_list.compact!
    return MembershipDecorator.decorate_collection(team_invitation_list)
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
