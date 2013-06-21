class UserStoryDecorator < Draper::Decorator
  decorates :user_story
  delegate_all

  def estimated
    plurify((object.estimate_in_quarter_days.to_f / 4), "day")
  end

private

  def plurify(num, word)
    return "#{num} #{word.pluralize}" if num < 1
    return "#{num} #{word}" if num == 1
    return "#{num} #{word.pluralize}"
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
