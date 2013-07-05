module ActivityTracker

  class ActivityTracker
    attr_reader :trackable, :project, :information, :args, :args_hash, :current_user

    def initialize(t, p, i=nil)
      @trackable = t
      @project = p
      @information = i
      @action = parameters[:action]
      @current_user = current_user
      @args = [team_id, project_id, trackable, information]
      @args_hash = {}
      @args.each { |a| @args_hash.merge!(a) }
    end

    def track_activity
      @current_user.activities.create(@args_hash)
    end

    def action
      {action: @action}
    end

    def team_id
      {team_id: @project.team.id}
    end

    def project_id
      {project_id: @project.id}
    end

    def trackable
      {trackable: @trackable}
    end

    def information
      {information: @information}
    end
  end

  class TeamActivityTracker < ActivityTracker
    def team_id
      {team_id: @trackable.id}
    end

    def project_id
      {project_id: nil}
    end
  end

  class ProjectActivityTracker < ActivityTracker
    def team_id
      {team_id: @trackable.team.id}
    end

    def project_id
      {project_id: @trackable.id}
    end
  end

  class UserStoryActivityTracker < ActivityTracker
    def team_id
      {team_id: @project.team.id}
    end

    def project_id
      {project_id: @project.id}
    end
  end

end
