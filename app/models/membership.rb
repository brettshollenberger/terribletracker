class Membership < ActiveRecord::Base
  attr_accessible :joinable, :role, :user, :state, :inviter_id, :joinable_id, :joinable_type

  validates :role, :user, :joinable, :state, :user_id, :joinable_id, :joinable_type, {
    presence: true
  }

  validates :state, {
    inclusion: { :in => %w(pending active closed) }
  }

  validates :role, {
    inclusion: { :in => %w(owner collaborator client) }
  }

  validates_uniqueness_of :user_id, {
    :scope => [:joinable_id, :joinable_type]
  }

  belongs_to :user, {
    inverse_of: :memberships
  }

  belongs_to :joinable, {
    polymorphic: true
  }

  state_machine :state, :initial => :pending do
    after_transition :pending => :active, :do => :email_accepted_confirmations
    after_transition :pending => :closed, :do => :email_decline_confirmations
    after_transition :active => :closed, :do => :email_closed_confirmations
    after_transition :closed => :active, :do => :email_reopen_confirmations

    event :approve_membership do
      transition :pending => :active
    end

    event :decline_membership do
      transition :pending => :closed
    end

    event :remove_membership do
      transition :active => :closed
    end

    event :reopen_membership do
      transition :closed => :active
    end

    state :pending
    state :active
    state :closed

  end

  def email_accepted_confirmations
    InvitationAcceptedMailer.invitation_accepted_email_owner(user, project).deliver unless project.owner == inviter
    InvitationAcceptedMailer.invitation_accepted_email_inviter(user, project).deliver
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

  def inviter
    User.find(inviter_id)
  end

  def project
    Project.find(joinable_id) if joinable_type == "Project"
  end

  def team
    Team.find(joinable_id) if joinable_type == "Team"
  end

end
