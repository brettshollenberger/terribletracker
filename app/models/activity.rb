class Activity < ActiveRecord::Base
  belongs_to :user
  belongs_to :team
  belongs_to :trackable,
    :polymorphic => true
  attr_accessible :action, :trackable, :user, :information, :team, :team_id
end
