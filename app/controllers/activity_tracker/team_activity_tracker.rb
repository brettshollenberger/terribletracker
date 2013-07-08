module ActivityTracker

  class TeamActivityTracker < TerribleActivityTracker

    def team_id
      {team_id: @trackable.id}
    end

  end

end
