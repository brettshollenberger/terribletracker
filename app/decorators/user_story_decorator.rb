class UserStoryDecorator < Draper::Decorator
  delegate_all

  def estimated
    plurify((object.estimate_in_quarter_days.to_f / 4), "day")
  end

  def state_button
    h.content_tag :div,
      state_button_link + dropdowns,
      :class => "btn-group"
  end

private

  def plurify(num, word)
    return "#{num} #{word.pluralize}" if num < 1
    return "#{num} #{word}" if num == 1
    return "#{num} #{word.pluralize}"
  end

  def state_button_link
    h.link_to "#{state.capitalize}
      <span class = 'caret'>".html_safe,
      "#",
      :class => state_button_class_builder,
      "data-toggle" => "dropdown"
  end

  def state_button_class_builder
    return "btn dropdown-toggle state-btn" if state == "unstarted"
    return "btn btn-primary dropdown-toggle state-btn" if state == "started"
    return "btn btn-warning dropdown-toggle state-btn"if state == "review"
    return "btn btn-success dropdown-toggle state-btn" if state == "finished"
  end

  def dropdowns
    h.content_tag :ul, :class => "dropdown-menu" do
      dropdown_links.collect do |link|
        h.content_tag :li, link
      end.join.html_safe
    end
  end

  def dropdown_links
    [unstarted_link,
      started_link,
      review_link,
      finished_link]
  end

  def unstarted_link
    h.link_to "Unstarted",
      "/user_story/#{id}/unstarted"
  end

  def started_link
    h.link_to "Started",
    "/user_story/#{id}/started"
  end

  def review_link
    h.link_to "Review",
      "/user_story/#{id}/review"
  end

  def finished_link
    h.link_to "Finished",
    "/user_story/#{id}/finished"
  end

  def show_state
    state.capitalize
  end

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

end
