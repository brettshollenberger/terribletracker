require "spec_helper"

include Warden::Test::Helpers
Warden.test_mode!
include EmailSpec::Helpers
include EmailSpec::Matchers

describe InvitationAcceptedMailer do

  let(:ownership)                    { FactoryGirl.create(:active_team_ownership) }
  let(:team)                         { ownership.team }
  let(:owner)                        { team.owner }
  let(:active_team_collaboratorship) { FactoryGirl.create(:active_team_collaboratorship) }
  let(:active_collaborator)          { active_team_collaboratorship.user }
  let(:new_collaborator)             { FactoryGirl.create(:user) }

  before(:each) do
    active_team_collaboratorship.joinable = team
    active_team_collaboratorship.save

    login_as(active_collaborator, scope: :user)
    visit team_path(team)

    click_link "Add Team Member"
    fill_in "User's Email", with: new_collaborator.email
    click_button "Add Member"

    @new_membership = new_collaborator.memberships.first

    @email_team_owner = InvitationAcceptedMailer.
      team_invitation_accepted_email_owner(
        new_collaborator,
        team)

    @email_team_inviter = InvitationAcceptedMailer.
      team_invitation_accepted_email_inviter(
        new_collaborator,
        team)
  end

  context "invitation_accepted_email_owner mailer", type: :feature do

    it "is delivered to owner of the team" do
      @email_team_owner.should deliver_to(owner.email)
    end

    it "should contain the user's name in the message" do
      @email_team_owner.should have_body_text(new_collaborator.first_name)
    end

    it "should have the correct subject" do
      @email_team_owner.should have_subject("#{new_collaborator.first_name} joined #{team.name}")
    end

  end

  context "invitation_accepted_email_owner mailer", type: :feature do

    it "is delivered to the person that invited the new member" do
      @email_team_inviter.should deliver_to(@new_membership.inviter.email)
    end

    it "should contain the new_collaborator's name in the message" do
      @email_team_inviter.should have_body_text(new_collaborator.first_name)
    end

    it "should have the correct subject" do
      @email_team_inviter.should have_subject("#{new_collaborator.first_name} joined #{team.name}")
    end

  end

end
