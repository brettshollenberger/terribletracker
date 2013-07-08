class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name,
    :bio, :webpage, :project

  validates :first_name, :last_name, {
    presence: true
  }

  has_many :memberships, {
    :dependent => :destroy,
    :inverse_of => :user
  }

  has_many :projects, {
    through: :memberships,
    source: :joinable,
    source_type: 'Project'
  }

  has_many :teams, {
    through: :memberships,
    source: :joinable,
    source_type: 'Team'
  }

  has_many :comments,
    :dependent => :destroy

  has_many :user_stories, {
    inverse_of: :user
  }

  has_many :activities

  def recent_activities
    Activity.where("team_id IN (?)", self.decorate.active_teams).includes(:trackable, :user).order('created_at DESC')
  end

  def active_team_memberships
    Membership.where(user_id: id, state: "active", joinable_type: "Team").includes(:user, :joinable).all
  end

  def pending_team_memberships
    Membership.where(user_id: id, state: "pending", joinable_type: "Team").all
  end

end
