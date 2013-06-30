require "spec_helper"

include Warden::Test::Helpers
Warden.test_mode!
include EmailSpec::Helpers
include EmailSpec::Matchers

describe InvitationAcceptedMailer do

  let(:ownership)               { FactoryGirl.create(:active_ownership) }
  let(:owner)                   { ownership.user }
  let(:project)                 { ownership.project }
  let(:new_collaborator)        { FactoryGirl.create(:user) }

  before(:each) do

    login_as(owner, scope: :user)
    visit project_path(project)

    click_link "Invite Collaborator"
    fill_in "User's Email", with: new_collaborator.email
    click_button "Invite Collaborator"

    @new_membership = new_collaborator.memberships.first

    @email = CollaborationInvitationMailer.
      collaboration_invitation_email(
        new_collaborator,
        project)
  end

  context "collaboration_invitation_email", type: :feature do

    it "is delivered to the invited user" do
      @email.should deliver_to(new_collaborator.email)
    end

    it "should contain the inviter's name in the message" do
      @email.should have_body_text("#{owner.first_name} #{owner.last_name}")
    end

    it "should have the correct subject" do
      @email.should have_subject("You've been invited to #{project.title} on Terrible Tracker")
    end

  end

end
