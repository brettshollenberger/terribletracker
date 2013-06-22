class Team < ActiveRecord::Base
  attr_accessible :description, :name, :owner_id, :website

  validates :name, :owner_id, {
    presence: true
  }

  validates :owner_id, {
    numericality: true
  }

  def owner
    User.where(id: owner_id)
  end

  def projects
    Project.where(team_id: id)
  end

  def clients
    client_list = []
    TeamMembership.where(team_id: id, role: "client").all.each { |membership| client_list.push(membership.user) }
    return client_list
  end
end
