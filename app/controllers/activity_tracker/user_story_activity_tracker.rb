module ActivityTracker

  class UserStoryActivityTracker < TerribleActivityTracker
    def team_id
      {team_id: @trackable.project.team.id}
    end

    def project_id
      {project_id: @trackable.project.id}
    end
  end

end
