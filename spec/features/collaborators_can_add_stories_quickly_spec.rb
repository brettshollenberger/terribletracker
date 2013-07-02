require 'spec_helper'

include Warden::Test::Helpers
Warden.test_mode!

feature 'collaborators can add user stories quickly', %q{
  As a user,
  When I visit the page for a project,
  I would like a new form to pop up in the same screen to enter my user stories,
  so that I can do my work more quickly, and see the results immediately.
} do

  # Acceptance Criteria:
  # User visits a project page, and clicks the add user story button.
  # The link raises the new story form on the same page; the user enters
  # their story information, and they see the new story on the same page
  # without needing to reload the entire page.

  context 'as a collaborator' do
    let(:ownership) { FactoryGirl.create(:active_team_ownership) }

    scenario 'adding a user story to a project', type: :feature, :js => true do
      @team = ownership.joinable
      @owner = ownership.user
      @project = FactoryGirl.create(:project, team: @team)

      login(@owner)

      visit_project_page(@team, @project)

      find('#right-sidebar').should have_content("New Story")

      fill_in 'user_story[title]', with: 'User can add user stories on the same page'
      fill_in 'user_story[story]', with: 'As a user, I would like to continue entering user stories from the projects page'

      click_on 'Create Story'

      find('#user_stories').should have_content('User can add user stories on the same page')
      @user_story = @project.user_stories.first
      expect(@user_story).to_not be_nil
      click_on @user_story.title
      find('#user_story_story').should have_content('As a user, I would like to continue entering user stories from the projects page')
    end
  end
end
