require 'spec_helper'

include Warden::Test::Helpers
Warden.test_mode!

feature 'collaborators and clients can decline their project invitations', %q{
  As a collaborator or client,
  I would like to decline my invitations,
  so that I don't have to see projects I don't want to work on.
} do
  # Acceptance Criteria:
  # User visits their homepage, and sees their project invitations.
  # User clicks decline, and the project is removed from their view.

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

    scenario 'declining invitations' do
      click_link "Decline"

      expect(page).to have_content("You've declined")
      expect(page).to_not have_content(@project.title)
    end
  end
end