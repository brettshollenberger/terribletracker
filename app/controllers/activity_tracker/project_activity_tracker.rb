module ActivityTracker

  class ProjectActivityTracker < TerribleActivityTracker
    def team_id
      {team_id: @trackable.team.id}
    end

    def project_id
      {project_id: @trackable.id}
    end
  end

end
