require 'spec_helper'

include Warden::Test::Helpers
Warden.test_mode!

feature 'collaborators and clients can accept project invitations', %q{
  As a collaborator or client,
  I would like to accept my invitations,
  so that I can join projects.
} do
  # Acceptance Criteria:
  # User visits their homepage, and sees that they have an invitation.
  # They click the accept button, and the project is added to their
  # projects list on their homepage and in their navbar.

  context 'as a collaborator' do
    let(:ownership)        { FactoryGirl.create(:active_ownership) }
    let(:collaboratorship) { FactoryGirl.create(:active_collaboratorship) }
    let(:new_collaborator) { FactoryGirl.create(:user) }

    background do
      @owner = ownership.user
      @project = ownership.project
      collaboratorship.joinable = @project
      collaboratorship.save
      @collaborator = collaboratorship.user
      login_as(@collaborator, scope: :user)
      visit project_path(@project)
      click_link "Add Collaborator"
      fill_in "User's Email", with: new_collaborator.email
      click_button "Add Collaborator"
      logout(@collaborator)
      login_as(new_collaborator, scope: :user)
      visit projects_path
    end

    scenario 'accepting invitations' do
      click_link "Accept"

      expect(page).to have_content("You're a collaborator!")
      expect(page).to have_content(@project.title)
    end
  end
end
