class Project < ActiveRecord::Base
  attr_accessible :budget, :description, :title, :weekly_rate

  validates :title, :description, {
    presence: true
  }

  has_many :memberships, {
    dependent: :destroy,
    inverse_of: :project
  }

  has_many :users, {
    through: :memberships
  }

  has_many :user_stories, {
    dependent: :destroy,
    inverse_of: :project
  }

  def owner
    self.memberships.each do |membership|
      return membership.user if membership.role == "owner"
    end
  end
end
