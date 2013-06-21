class UserStory < ActiveRecord::Base
  attr_accessible :state, :complexity, :estimate_in_quarter_days, :project_id, :story, :title

  belongs_to :project, {
    inverse_of: :user_stories
  }

  validates :story, :title, :project, {
    presence: true
  }

  validates :project_id, {
    numericality: true
  }

  validates :state, {
    inclusion: { :in => %w(unstarted started review finished) }
  }
end
