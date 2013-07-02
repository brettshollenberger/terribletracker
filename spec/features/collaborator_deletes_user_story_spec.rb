require 'spec_helper'

include Warden::Test::Helpers
Warden.test_mode!

feature 'collaborator deletes user story', %q{
  As a owner or collaborator,
  I want to delete user stories,
  so that I can keep the project scope up-to-date.
} do
  # Acceptance Criteria:
  # User visits a project page, and clicks the user story title to edit it.
  # The link raises the edit form; on save, the user is informed that
  # they have updated the story successfully, and they can see the updated
  # story on the project page.

  context 'as a collaborator', js: true do

    background do
      @membership = FactoryGirl.create(:active_team_membership)
      @team = @membership.joinable
      @project = FactoryGirl.create(:project, team: @team)
      @user = @membership.user
      @user_story = FactoryGirl.create(:user_story, project: @project)

      login(@user)

      visit root_path
    end

    scenario 'adding a user story to a project' do
      find("#team_name_#{@team.id}").click
      find("#project_#{@project.id}").click
      expect(page).to have_content('Terrible Story')

      click_on "Delete"

      expect(page).to_not have_content('Terrible Story')
    end
  end
end
