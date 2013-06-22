require 'spec_helper'

include Warden::Test::Helpers
Warden.test_mode!

feature 'collaborators and clients can see their invitations', %q{
  As a collaborator or client,
  I would like to see the projects I am invited to,
  so that I can decide whether or not to join them.
} do
  # Acceptance Criteria:
  # user stories have a title, story, estimate (in increments of .25 days), an actual time spent, and a complexity.
  # They belong to projects and users (assigned to them).

  context 'as a collaborator' do
    let(:ownership)  { FactoryGirl.create(:active_ownership) }
    let(:user) { FactoryGirl.create(:user) }

    background do
      @owner = ownership.user
      @project = ownership.project
      login_as(@owner, scope: :user)
      visit project_path(@project)
      click_link "Add Collaborator"
      fill_in "User's Email", with: user.email
      click_button "Add Collaborator"
      logout(@owner)
      login_as(user, scope: :user)
      visit projects_path
    end

    scenario 'seeing invitations' do
      expect(page).to have_content("Invitations")
      expect(page).to have_content(@project.owner.first_name)
      expect(page).to have_content(@project.owner.last_name)
      expect(page).to have_content("My Awesome Project")
      expect(page).to have_content("Accept Invitation")
      expect(page).to have_content("Decline Invitation")
    end
  end
end
