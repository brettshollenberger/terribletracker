class MembershipDecorator < Draper::Decorator
  delegate_all

  def actions_dropdown
    h.content_tag :div,
      actions_dropdown_link + dropdowns,
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
    h.link_to "Decline", "/membership/#{id}/decline"
  end

end
