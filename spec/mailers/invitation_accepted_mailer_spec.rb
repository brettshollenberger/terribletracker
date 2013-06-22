require "spec_helper"

include Warden::Test::Helpers
Warden.test_mode!

describe InvitationAcceptedMailer do
  include EmailSpec::Helpers
  include EmailSpec::Matchers

  describe "invitation_accepted_email_owner", type: :feature do
    let(:ownership)        { FactoryGirl.create(:active_ownership) }
    let(:owner)            { ownership.user }
    let(:project)          { ownership.project }
    let(:new_collaborator) { FactoryGirl.create(:user) }

    before(:each) do
      login_as(owner, scope: :user)
      visit project_path(project)

      click_link "Add Collaborator"
      fill_in "User's Email", with: new_collaborator.email
      click_button "Add Collaborator"

      @email = InvitationAcceptedMailer.
        invitation_accepted_email_owner(
          new_collaborator,
          project)
    end

    it "is delivered to owner of the project" do
      @email.should deliver_to(project.owner.email)
    end

    it "should contain the user's name in the message" do
      @email.should have_body_text(owner.first_name)
    end

    it "should have the correct subject" do
      @email.should have_subject("#{new_collaborator.first_name} joined #{project.title}")
    end
  end
end
