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

  def projects_dropdown
    unless self.active_projects.empty?
      h.content_tag :li, :class => "dropdown" do
        projects_dropdown_link_header +
        h.content_tag(:ul, "", :class => "dropdown-menu") do
          wrap_dropdown_links(project_dropdown_links).join.html_safe
        end
      end
    end
  end

  def projects_dropdown_link_header
    h.link_to("#{self.first_name}'s
      Projects <b class='caret'></b>".html_safe,
        "#",
        :class => "dropdown-toggle",
        "data-toggle" => "dropdown")
  end

  def wrap_dropdown_links(link_type)
    link_type.collect do |link|
      h.content_tag :li, link
    end
  end

  def project_dropdown_links
    inners = []
    self.active_projects.each do |project|
      inners.push(h.link_to "#{project.title}", "/projects/#{project.id}")
    end
    return inners
  end

  def teams_dropdown
    unless self.active_teams.empty?
      h.content_tag :li, :class => "dropdown" do
        teams_dropdown_link_header +
        h.content_tag(:ul, "", :class => "dropdown-menu") do
          wrap_dropdown_links(team_dropdown_links).join.html_safe
        end
      end
    end
  end

  def teams_dropdown_link_header
    h.link_to("Teams <b class='caret'></b>".html_safe,
        "#",
        :class => "dropdown-toggle",
        "data-toggle" => "dropdown")
  end

  def team_dropdown_links
    inners = []
    self.active_teams.each do |team|
      inners.push(h.link_to "#{team.name}", "/teams/#{team.id}")
    end
    return inners
  end

  # <% unless current_user.active_teams.empty? %>
  #                <li class="dropdown">
  #                  <a href="#" class="dropdown-toggle" data-toggle="dropdown"> Teams <b class="caret"></b></a>
  #                  <ul class="dropdown-menu">
  #                    <% current_user.active_teams.each do |team| %>
  #                      <li>
  #                         <%= link_to "#{team.name}", team_path(team) %>
  #                      </li>
  #                    <% end %>
  #                  </ul>
  #                </li>

end
