class Project < ActiveRecord::Base
  attr_accessible :budget, :description, :title, :weekly_rate, :team

  validates :title, :description, {
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

  belongs_to :team, {
    inverse_of: :projects
  }

  def owner
    self.memberships.each do |membership|
      return membership.user if membership.role == "owner"
    end
  end
end
