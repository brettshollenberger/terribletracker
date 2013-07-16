class UserStoryDecorator < Draper::Decorator
  delegate_all

  def estimated
    plurify(estimate_in_quarter_days, "day")
  end

  def state_button
    h.content_tag :div,
      state_button_link + dropdowns,
      :class => "btn-group"
  end

  def assign_button
    h.content_tag :div,
      assign_button_link + assign_dropdowns,
      :class => "btn-group"
  end

private

  def plurify(num, word)
    return "#{num} #{word.pluralize}" if num < 1
    return "#{num} #{word}" if num == 1
    return "#{num} #{word.pluralize}"
  end

  # def estimize(obj)
  #   estimate = obj.estimate_in_quarter_days.to_f / 4
  #   return strfy(estimate)
  # end

  # def strfy(num)
  #   str = num.to_s
  #   return str[0..-2].to_i if str[-1] == "0" && str[-2] == "."
  #   return num
  # end

  def state_button_link
    h.link_to "#{state.capitalize}
      <span class = 'caret'>".html_safe,
      "#",
      :class => state_button_class_builder,
      "data-toggle" => "dropdown"
  end

  def state_button_class_builder
    return "btn dropdown-toggle state-btn unstarted-dropdown" if state == "unstarted"
    return "btn btn-primary dropdown-toggle state-btn started-dropdown" if state == "started"
    return "btn btn-warning dropdown-toggle state-btn review-dropdown"if state == "review"
    return "btn btn-success dropdown-toggle state-btn finished-dropdown" if state == "finished"
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
    h.link_to "Unstarted", "/user_story/#{id}/unstarted", remote: true, :class => "unstarted-btn"
  end

  def started_link
    h.link_to "Started", "/user_story/#{id}/started", remote: true, :class => "started-btn"
  end

  def review_link
    h.link_to "Review", "/user_story/#{id}/review", remote: true, :class => "review-btn"
  end

  def finished_link
    h.link_to "Finished", "/user_story/#{id}/finished", remote: true, :class => "finished-btn"
  end

  def assign_button_link
    h.link_to "#{assign_link}
      <span class = 'caret'>".html_safe,
      "#",
      :class => "btn dropdown-toggle assign-button",
      "data-toggle" => "dropdown"
  end

  def assign_link
    return self.user.decorate.full_name unless self.user == nil
    "Assign"
  end

  def assign_dropdowns
    h.content_tag :ul, :class => "dropdown-menu" do
      assign_dropdown_links.collect do |link|
        h.content_tag :li, link
      end.join.html_safe
    end
  end

  def assign_dropdown_links
    dropdown_links = []
    self.project.active_users.each do |user|
      dropdown_links.push(h.link_to "#{user.decorate.full_name}",
        "/user_story/#{id}/assign/#{user.id}", remote: true)
    end
    return dropdown_links
  end

end
