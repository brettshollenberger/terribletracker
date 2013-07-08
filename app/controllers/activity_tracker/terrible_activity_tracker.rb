module ActivityTracker

  class TerribleActivityTracker
    attr_reader :trackable, :args, :args_hash

    def initialize(t, a, i=nil)
      @trackable = t
      @information = i
      @action = a
      @args = [team_id, project_id, action, trackable, information]
      @args_hash = {}
      binding.pry
      @args.each { |a| @args_hash.merge!(a) }
    end

    def track_activity(current_user)
      current_user.activities.create(@args_hash)
    end

    def action
      {action: @action}
    end

    def team_id
    end

    def project_id
    end

    def trackable
      {trackable: @trackable}
    end

    def information
      {information: @information}
    end
  end

end
