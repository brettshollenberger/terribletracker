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
    self.memberships.each do |membership|
      return membership.user if membership.role == "owner"
    end
  end

  def active_users
    self.memberships.where(state: "active").collect { |membership| membership.user }
  end
end
