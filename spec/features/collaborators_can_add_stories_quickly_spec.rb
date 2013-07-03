require 'spec_helper'

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

    background do
      create_team_with_project
      login(@owner)
      visit_project_path(@project)
    end

    scenario 'adding a user story to a project', type: :feature, :js => true do
      find('#right-sidebar').should have_content("New Story")

      fill_in 'user_story[title]', with: 'User can add user stories on the same page'
      fill_in 'user_story[story]', with: 'As a user, I would like to continue entering user stories from the projects page'

      click_on 'Create Story'

      find('#user_stories').should have_content('User can add user stories on the same page')
      @story2 = @project.user_stories[1]
      expect(@story2.title).to eql("User can add user stories on the same page")
      expect(@story2.story).to eql("As a user, I would like to continue entering user stories from the projects page")
    end
  end
end
