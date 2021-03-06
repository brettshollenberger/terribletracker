class Membership < ActiveRecord::Base
  attr_accessible :joinable, :role, :user, :state, :inviter_id, :joinable_id, :joinable_type, :inviter

  validates :role, :user, :joinable, :state, :user_id, :joinable_id, :joinable_type, {
    presence: true
  }

  validates :state, {
    inclusion: { :in => %w(pending active inactive) }
  }

  validates :role, {
    inclusion: { :in => %w(owner collaborator client) }
  }

  validates_uniqueness_of :user_id, {
    :scope => [:joinable_id, :joinable_type]
  }

  belongs_to :inviter,
    :class_name => "User"

  belongs_to :user, {
    inverse_of: :memberships
  }

  belongs_to :joinable, {
    polymorphic: true
  }

  state_machine :state, :initial => :pending do
    after_transition :pending => :active, :do => :email_accepted_confirmations
    after_transition :active => :inactive, :do => :email_closed_confirmations
    after_transition :inactive => :active, :do => :email_reopen_confirmations

    event :approve_membership do
      transition :pending => :active
    end

    event :deactivate do
      transition :active => :inactive
    end

    event :activate do
      transition :inactive => :active
    end

    state :pending
    state :active
    state :inactive

  end

  def email_accepted_confirmations
    InvitationAcceptedMailer.team_invitation_accepted_email_owner(user, team).deliver unless team.owner == inviter
    InvitationAcceptedMailer.team_invitation_accepted_email_inviter(user, team).deliver
  end

  def email_pending_confirmations
    puts "Email pending confirmation"
    puts "Here are the confirmations you ordered"
  end

  def email_decline_confirmations
    print "Email decline confirmations"
  end

  def email_closed_confirmations
    print "Email closed confirmations"
  end

  def email_reopen_confirmations
    print "Email reopen confirmations"
  end

  def project
    Project.find(joinable_id) if joinable_type == "Project"
  end

  def team
    Team.find(joinable_id) if joinable_type == "Team"
  end

end
