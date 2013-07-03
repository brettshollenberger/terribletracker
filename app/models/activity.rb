class Activity < ActiveRecord::Base
  attr_accessible :action, :trackable, :user, :information, :team, :team_id, :project, :project_id

  belongs_to :user
  belongs_to :team
  belongs_to :project
  belongs_to :trackable,
    :polymorphic => true

  validates :user, :team, :trackable, {
    presence: true
  }

  validates :trackable_type, {
    inclusion: { :in => %w(UserStory Project Comment Membership Team) }
  }

end
