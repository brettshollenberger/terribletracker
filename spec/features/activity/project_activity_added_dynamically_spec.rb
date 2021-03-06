require 'spec_helper'

feature "project page displays activity dynamically", %q{
  As a user,
  I want to see my new activity added to the project page
  as I complete it, so that I can be sure I've made the change.
} do
  # Acceptance Criteria:
  # User visits the page for a project, and makes changes:
  # 1) writes a new user story, 2) assigns a collaborator to
  # the story, and 3) marks the story as started. All three
  # activities are loaded into the Recent Activities section
  # on the project page as the user finishes them, without them
  # having to reload the page.

  context 'as a user' do

    background do
      create_team_with_project
      login(@owner)
      visit_project_path(@project)
    end

    scenario "creating a user story", js: true do
      find('#right-sidebar').should have_content("New Story")

      fill_in 'user_story[title]', with: 'User can add user stories on the same page'
      fill_in 'user_story[story]', with: 'As a user, I would like to continue entering user stories from the projects page'

      click_on 'Create Story'

      find('#project-activities-table').should have_content("#{@owner.full_name} created user story User can add user stories on the same page")
      find('#project-activities-table').should_not have_content("No activities to show yet.")
    end

    scenario "assigning a collaborator to a user story", js: true do
      find('.assign-button').click
      page.should have_content(@collaborator.full_name)
      click_on @collaborator.full_name

      find('#project-activities-table').should have_content("#{@owner.full_name} assigned #{@collaborator.full_name} to #{@story.title}")
      find('#project-activities-table').should_not have_content("No activities to show yet.")
    end

    scenario "changing the state of a user story", js: true do
      find('.state-btn').click
      page.should have_content("Started")
      find('.started-btn').click

      find('#project-activities-table').should have_content("#{@owner.full_name} started #{@story.title}")
      find('#project-activities-table').should_not have_content("No activities to show yet.")
    end

  end
end
