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
end
