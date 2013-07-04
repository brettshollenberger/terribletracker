class Project < ActiveRecord::Base
  attr_accessible :budget, :description, :title, :weekly_rate, :team, :team_id

  validates :title, :team, {
    presence: true
  }

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
    Activity.where(project_id: id).order("created_at desc").all
  end
end
