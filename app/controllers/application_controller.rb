class ApplicationController < ActionController::Base
  protect_from_forgery

  def current_user
    UserDecorator.decorate(super) unless super.nil?
  end

  def track_user_story_activity(trackable, project=@project, information=nil, action=params[:action])
    current_user.activities.create(action: action, team_id: project.team.id, project_id: project.id, trackable: trackable, information: information)
  end

  def track_team_activity(trackable, team=@team, information=nil, action=params[:action])
    current_user.activities.create(action: action, team_id: @team.id, project_id: nil, trackable: trackable, information: information)
  end

end
