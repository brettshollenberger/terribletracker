class Project < ActiveRecord::Base
  attr_accessible :budget, :description, :title, :weekly_rate, :team, :team_id, :state

  validates :title, :team, :state, {
    presence: true
  }

  validates :state, {
    inclusion: { :in => %w(active inactive) }
  }

  validates_uniqueness_of :title, scope: [:team_id]

  has_many :memberships, {
    :as => :joinable,
    :dependent => :destroy
  }

  has_many :users, {
    through: :memberships
  }

  has_many :activities, {
    as: :trackable
  }

  has_many :user_stories, {
    dependent: :destroy,
    inverse_of: :project
  }

  has_many :comments,
    :as => :commentable,
    :dependent => :destroy

  belongs_to :team, {
    inverse_of: :projects
  }

  scope :active, -> { where(state: "active") }

  scope :inactive, -> { where(state: "inactive") }

  state_machine :state, :initial => :active do

    event :deactivate do
      transition :active => :inactive
    end

    event :activate do
      transition :inactive => :active
    end

    state :active
    state :inactive

  end

  def owner
    self.memberships.where(role: "owner").first.user
  end

  def active_userships
    self.memberships.where(state: "active").includes(:user).all
  end

  def active_users
    users = []
    self.active_userships.each do |usership|
      users.push(usership.user)
    end
    return users
  end

  def activities
    Activity.where(project_id: id).order("created_at desc").limit(5)
  end

  def project
    self
  end

end
