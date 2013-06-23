class UserDecorator < Draper::Decorator
  delegate_all

  def active_projects
    active_projects_list = []
    self.memberships.each do |membership|
      if membership.joinable_type == "Project"
        active_projects_list.push(membership.project) if membership.state == "active"
      end
    end
    return active_projects_list
  end

  def invitations
    invitation_list = []
    self.memberships.each do |membership|
      if membership.joinable_type == "Project"
        invitation_list.push(membership) if membership.state == "pending"
     end
    end
    invitation_list.compact!
    return MembershipDecorator.decorate_collection(invitation_list)
  end

  def gravatar
    gravatar_id = Digest::MD5.hexdigest(self.email.downcase)
    h.link_to("https://en.gravatar.com/emails/") do
      h.image_tag "http://gravatar.com/avatar/#{gravatar_id}.png?s=150"
    end
  end

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

end
