require "spec_helper"

include EmailSpec::Helpers
include EmailSpec::Matchers

describe TeamInvitationMailer do

  before(:each) do
    create_team_with_project
    @new_collaborator = FactoryGirl.create(:user)
    visit root_path

    login(@owner)

    find("#team_name_#{@team.id}").click

    click_link "Invite Collaborator"
    fill_in "User's Email", with: @new_collaborator.email
    click_button "Add Member"

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
      @email.should have_body_text("#{@owner.first_name} #{@owner.last_name}")
    end

    it "should have the correct subject" do
      @email.should have_subject("You've been invited to #{@team.name} on Terrible Tracker")
    end

  end

end
