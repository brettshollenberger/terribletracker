class CommentDecorator < Draper::Decorator
  delegate_all

  # Clock argument for testing; defaults to Time
  def pretty_created_at(clock=Time.now)
    a = (clock-self.created_at).to_i

    return 'just now' if a == 0
    return 'a second ago' if a == 1
    return a.to_s+' seconds ago' if a >= 2 && a <= 59
    return 'a minute ago' if a >= 60 && a <= 119 #120 = 2 minutes
    return (a/60).to_i.to_s+' minutes ago' if a >= 120 && a <= 3540
    return 'an hour ago' if a >= 3541 && a <= 7100 # 3600 = 1 hour
    return "Today at#{self.created_at.strftime("%l:%M%p")}" if a >= 7101 && a <= 82800
    return "Yesterday at#{self.created_at.strftime("%l:%M%p")}" if a >= 82801 && a <= 165600
    if clock.strftime("%A") == "Sunday"
      return "This #{self.created_at.strftime("%A")} at #{self.created_at.strftime("%l:%M%p")}" if a >= 165601 && a <= 579600
      return "#{self.created_at.strftime("%A %B %e")} at #{self.created_at.strftime("%l:%M%p")}" if a >= 579601
    elsif clock.strftime("%A") == "Saturday"
      return "This #{self.created_at.strftime("%A")} at#{self.created_at.strftime("%l:%M%p")}" if a >= 165601 && a <= 496800
      return "#{self.created_at.strftime("%A %B %e")} at#{self.created_at.strftime("%l:%M%p")}" if a >= 496801
    elsif clock.strftime("%A") == "Friday"
      return "This #{self.created_at.strftime("%A")} at#{self.created_at.strftime("%l:%M%p")}" if a >= 165601 && a <= 414000
      return "#{self.created_at.strftime("%A %B %e")} at#{self.created_at.strftime("%l:%M%p")}" if a >= 414001
    elsif clock.strftime("%A") == "Thursday"
      return "This #{self.created_at.strftime("%A")} at#{self.created_at.strftime("%l:%M%p")}" if a >= 165601 && a <= 331200
      return "#{self.created_at.strftime("%A %B %e")} at#{self.created_at.strftime("%l:%M%p")}" if a >= 331201
    elsif clock.strftime("%A") == "Wednesday"
      return "This #{self.created_at.strftime("%A")} at#{self.created_at.strftime("%l:%M%p")}" if a >= 165601 && a <= 248400
      return "#{self.created_at.strftime("%A %B %e")} at#{self.created_at.strftime("%l:%M%p")}" if a >= 248401
    else
      return "#{self.created_at.strftime("%A %B %e")} at#{self.created_at.strftime("%l:%M%p")}" if a >= 165600
    end
  end
end
