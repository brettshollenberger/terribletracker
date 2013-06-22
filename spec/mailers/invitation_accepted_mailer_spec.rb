require "spec_helper"

include Warden::Test::Helpers
Warden.test_mode!
include EmailSpec::Helpers
include EmailSpec::Matchers

describe InvitationAcceptedMailer do

  let(:ownership)               { FactoryGirl.create(:active_ownership) }
  let(:owner)                   { ownership.user }
  let(:project)                 { ownership.project }
  let(:active_collaboratorship) { FactoryGirl.create(:active_collaboratorship) }
  let(:active_collaborator)     { active_collaboratorship.user }
  let(:new_collaborator)        { FactoryGirl.create(:user) }

  before(:each) do
    active_collaboratorship.joinable = project
    active_collaboratorship.save

    login_as(active_collaborator, scope: :user)
    visit project_path(project)

    click_link "Add Collaborator"
    fill_in "User's Email", with: new_collaborator.email
    click_button "Add Collaborator"

    @new_membership = new_collaborator.memberships.first

    @email_owner = InvitationAcceptedMailer.
      invitation_accepted_email_owner(
        new_collaborator,
        project)

    @email_inviter = InvitationAcceptedMailer.
      invitation_accepted_email_inviter(
        new_collaborator,
        project)
  end

  context "invitation_accepted_email_owner mailer", type: :feature do

    it "is delivered to owner of the project" do
      @email_owner.should deliver_to(project.owner.email)
    end

    it "should contain the user's name in the message" do
      @email_owner.should have_body_text(owner.first_name)
    end

    it "should have the correct subject" do
      @email_owner.should have_subject("#{new_collaborator.first_name} joined #{project.title}")
    end

  end

  context "invitation_accepted_email_owner mailer", type: :feature do

    it "is delivered to the person that invited " do
      @email_inviter.should deliver_to(@new_membership.inviter.email)
    end

    it "should contain the user's name in the message" do
      @email_inviter.should have_body_text(owner.first_name)
    end

    it "should have the correct subject" do
      @email_inviter.should have_subject("#{new_collaborator.first_name} joined #{project.title}")
    end

  end

end
