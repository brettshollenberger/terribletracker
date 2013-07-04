class Team < ActiveRecord::Base
  attr_accessible :description, :name, :owner_id, :website

  belongs_to :owner,
    class_name: 'User'

  validates :name, :owner_id, {
    presence: true
  }

  validates :name, {
    uniqueness: true
  }

  validates :owner_id, {
    numericality: true
  }

  has_many :memberships, {
    :as => :joinable,
    :dependent => :destroy
  }

  # has_many :members,
  #   class_name: 'User',
  #   through: :memberships,
  #   source: :user

  has_many :projects, {
    dependent: :destroy,
    inverse_of: :team
  }

  has_many :activities,
    :as => :trackable

  def projects
    Project.where(team_id: id)
  end

  def owner
    Membership.where(joinable_id: id, joinable_type: "Team", role: "owner", state: "active").first.user
  end

  def clients
    client_list = []
    Membership.where(joinable_id: id, joinable_type: "Team", role: "client", state: "active").all.each { |membership| client_list.push(membership.user) }
    return client_list
  end

  def active_memberships
    self.memberships.where(state: "active").includes(:user).all
  end

  def members
    members = []
    self.active_memberships.each do |member|
      members.push(member.user)
    end
    return UserDecorator.decorate_collection(members)
  end

  def pending_members
    members_list = []
    Membership.where(joinable_id: id, joinable_type: "Team", role: "collaborator", state: "pending").all.each { |membership| members_list.push(membership.user) }
    return UserDecorator.decorate_collection(members_list)
  end

  def activities
    Activity.where(team_id: self.id).order("created_at desc").all
  end
end
