class Team < ActiveRecord::Base
  attr_accessible :description, :name, :owner_id, :website

  validates :name, :owner_id, {
    presence: true
  }

  validates :owner_id, {
    numericality: true
  }

  has_many :memberships, {
    :as => :joinable,
    :dependent => :destroy
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

  def members
    members_list = []
    TeamMembership.where(team_id: id, role: "collaborator").all.each { |membership| members_list.push(membership.user) }
    return members_list << owner
  end
end
