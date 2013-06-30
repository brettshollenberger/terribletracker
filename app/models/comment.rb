class Comment < ActiveRecord::Base
  attr_accessible :body, :commentable, :user

  validates :body, :commentable, :user, {
    presence: true
  }

  validates :commentable_id, :user_id, {
    numericality: true
  }

  validates_uniqueness_of :body, scope: [:user_id, :commentable_id, :commentable_type]

  validates :commentable_type, {
    inclusion: { :in => %w(UserStory Project) }
  }

  belongs_to :commentable,
    :polymorphic => true

  belongs_to :user, {
    inverse_of: :comments
  }
end
