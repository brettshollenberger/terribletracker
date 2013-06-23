require "spec_helper"

include Warden::Test::Helpers
Warden.test_mode!
include EmailSpec::Helpers
include EmailSpec::Matchers

describe TeamInvitationMailer do

  let(:ownership)               { FactoryGirl.create(:active_team_ownership) }
  let(:team)                    { ownership.team }
  let(:owner)                   { team.owner }
  let(:new_collaborator)        { FactoryGirl.create(:user) }

  before(:each) do

    login_as(owner, scope: :user)
    visit team_path(team)

    click_link "Add Team Member"
    fill_in "User's Email", with: new_collaborator.email
    click_button "Add Member"

    @new_membership = new_collaborator.memberships.first

    @email = TeamInvitationMailer.
      team_invitation_email(
        new_collaborator,
        team)
  end

  context "team_invitation_email", type: :feature do

    it "is delivered to the invited user" do
      @email.should deliver_to(new_collaborator.email)
    end

    it "should contain the inviter's name in the message" do
      @email.should have_body_text("#{owner.first_name} #{owner.last_name}")
    end

    it "should have the correct subject" do
      @email.should have_subject("You've been invited to #{team.name} on Terrible Tracker")
    end

  end

end
