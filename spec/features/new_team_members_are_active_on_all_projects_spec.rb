require 'spec_helper'

include Warden::Test::Helpers
Warden.test_mode!

feature 'new team members are automatically added to all projects', %q{
  As a new team member,
  I want to automatically be added to the teams' projects,
  so I can get started right away.
} do

  # Acceptance Criteria:
  # New team member accepts team invitation,
  # and is automatically added to all projects. They can
  # view the teams' projects on the team page, and in their nav.

  context 'as a new member' do

    background do
      @ownership = FactoryGirl.create(:active_team_ownership)
      @project_ownership = FactoryGirl.create(:active_ownership)
      @new_collaborator = FactoryGirl.create(:user)
      @owner = @ownership.user
      @team = @ownership.team
      @project = @project_ownership.project
      @project_ownership.user = @owner
      @project_ownership.save
      @project_ownership.reload

      login_as(@owner, scope: :user)
      visit team_path(@team)
      click_link "Add Team Member"
      fill_in "User's Email", with: @new_collaborator.email
      click_button "Add Member"
      logout(@owner)

      login_as(@new_collaborator, scope: :user)
      visit root_path
    end

    scenario 'accepts invitation' do

      click_link "Accept"

      expect(page).to have_content("You're a collaborator!")
      expect(page).to have_content(@team.name)
      expect(page).to have_content(@project.title)
    end
  end
end
