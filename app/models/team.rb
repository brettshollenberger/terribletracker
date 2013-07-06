class Team < ActiveRecord::Base
  attr_accessible :description, :name, :owner_id, :website

  belongs_to :owner,
    class_name: 'User'

  validates :name, :owner_id, {
    presence: true
  }

  validates_uniqueness_of :name, scope: [:owner_id]

  validates :owner_id, {
    numericality: true
  }

  has_many :memberships, {
    :as => :joinable,
    :dependent => :destroy
  }

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

  def active_clientships
    self.memberships.where(role: "client", state: "active").includes(:user).all
  end

  def clients
    clients = []
    self.active_clientships.each do |clientship|
      clients.push(clientship.user)
    end
    return UserDecorator.decorate_collection(clients)
  end

  def active_memberships
    self.memberships.where(state: "active").includes(:user).all
  end

  def members
    members = []
    self.active_memberships.each do |membership|
      members.push(membership.user)
    end
    return UserDecorator.decorate_collection(members)
  end

  def pending_memberships
    self.memberships.where(state: "pending").includes(:user).all
  end

  def pending_members
    members = []
    self.pending_memberships.each do |membership|
      members.push(membership.user)
    end
    return UserDecorator.decorate_collection(members)
  end

  def activities
    Activity.where(team_id: id).order("created_at desc").limit(5)
  end
end
