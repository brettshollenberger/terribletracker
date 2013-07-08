class ApplicationController < ActionController::Base
  protect_from_forgery

  def current_user
    UserDecorator.decorate(super) unless super.nil?
  end

  def track_activity(trackable, information=nil, action=params[:action])
    current_user.activities.create(
      action: action,
      team: trackable.team,
      project: trackable.project,
      trackable: trackable,
      information: information)
  end

end
