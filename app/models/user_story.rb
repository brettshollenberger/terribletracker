class UserStory < ActiveRecord::Base
  attr_accessible :state, :complexity, :estimate_in_quarter_days, :project_id, :story, :title, :user

  belongs_to :project, {
    inverse_of: :user_stories
  }

  belongs_to :user, {
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

  state_machine :state, :initial => :unstarted do
    after_transition any => :started, :do => :add_to_active_stories
    after_transition any => :review, :do => :add_to_review_stories
    after_transition any => :finished, :do => :remove_from_active_stories
    after_transition any => :finished, :do => :remove_from_review_stories

    event :start do
      transition [:unstarted, :review, :finished] => :started
    end

    event :mark_for_review do
      transition [:unstarted, :started, :finished] => :review
    end

    event :finish do
      transition [:unstarted, :started, :review] => :finished
    end

    event :unstart do
      transition [:started, :review, :finished] => :unstarted
    end

    state :unstarted
    state :started
    state :review
    state :finished

  end

  def add_to_active_stories
    puts "Added to active stories"
  end

  def add_to_review_stories
    puts "Added to review stories"
  end

  def remove_from_active_stories
    puts "Removed from active stories"
  end

  def remove_from_review_stories
    puts "Removed from review stories"
  end

end
