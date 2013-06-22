class UserDecorator < Draper::Decorator
  delegate_all

  def active_projects
    active_projects_list = []
    self.memberships.each { |membership| active_projects_list.push(membership.project) if membership.state == "active" }
    return active_projects_list
  end

  def invitations
    invitation_list = []
    self.memberships.each { |membership| invitation_list.push(membership) if membership.state == "pending" }
    return MembershipDecorator.decorate_collection(invitation_list)
  end

end
