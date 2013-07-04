class MembershipDecorator < Draper::Decorator
  delegate_all

  def actions_dropdown
    h.content_tag :div,
      actions_dropdown_link + dropdowns,
      :class => "btn-group"
  end

  def team_actions_dropdown
    h.content_tag :div,
      actions_dropdown_link + team_dropdowns,
      :class => "btn-group"
  end

private
  def actions_dropdown_link
    h.link_to "Action
      <span class = 'caret'>".html_safe,
      "#",
      :class => "btn dropdown-toggle",
      "data-toggle" => "dropdown"
  end

  def dropdowns
    h.content_tag :ul, :class => "dropdown-menu" do
      dropdown_links.collect do |link|
        h.content_tag :li, link
      end.join.html_safe
    end
  end

  def dropdown_links
    [accept, decline]
  end

  def accept
    h.link_to "Accept", "/membership/#{id}/accept"
  end

  def decline
    h.link_to "Decline", "/membership/#{id}/decline", remote: true, :class => "decline-invitation"
  end

  def team_dropdowns
    h.content_tag :ul, :class => "dropdown-menu" do
      team_dropdown_links.collect do |link|
        h.content_tag :li, link
      end.join.html_safe
    end
  end

  def team_dropdown_links
    [accept_team, decline]
  end

  def accept_team
    h.link_to "Accept", "/membership/#{id}/accept",remote: true, :class => "accept-invitation"
  end

end
