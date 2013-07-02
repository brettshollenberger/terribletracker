require "spec_helper"

include Warden::Test::Helpers
Warden.test_mode!
include EmailSpec::Helpers
include EmailSpec::Matchers

describe TeamInvitationMailer do

  before(:each) do
    @active_team_ownership = FactoryGirl.create(:active_team_ownership)
    @active_owner = @active_team_ownership.user
    @team = @active_team_ownership.team
    @active_collaboratorship = FactoryGirl.create(:active_team_membership, joinable: @team)
    @active_collaborator = @active_collaboratorship.user
    @new_collaborator = FactoryGirl.create(:user)
    visit root_path

    login(@active_owner)

    find("#team_name_#{@team.id}").click

    click_link "Invite Collaborator"
    fill_in "User's Email", with: @new_collaborator.email
    click_button "Add Member"

    # Wait until collaborator invited notice appears on page
    # before looking for the new membership; strange
    # AJAX thing.
    find("#collaborator_notice").should have_content("invited")

    @new_membership = @new_collaborator.memberships.first

    @email = TeamInvitationMailer.
      team_invitation_email(
        @new_collaborator,
        @team)
  end

  context "team_invitation_email", type: :feature, js: true do

    it "is delivered to the invited user" do
      @email.should deliver_to(@new_collaborator.email)
    end

    it "should contain the inviter's name in the message" do
      @email.should have_body_text("#{@active_owner.first_name} #{@active_owner.last_name}")
    end

    it "should have the correct subject" do
      @email.should have_subject("You've been invited to #{@team.name} on Terrible Tracker")
    end

  end

end
