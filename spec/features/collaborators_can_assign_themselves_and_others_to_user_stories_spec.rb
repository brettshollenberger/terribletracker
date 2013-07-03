require 'spec_helper'

feature 'collaborators can assign themselves and others to user stories', %q{
  As a project collaborator,
  I would like to assign myself and my teammates to user stories,
  so that we can get to work.
} do

  # Acceptance Criteria:
  # User visits project page with user stories on it.
  # They click a dropdown to select a teammate to assign
  # as user story to.

  context 'as a new member' do

    background do
      create_team_with_project
      login(@owner)
      visit_project_path(@project)

      # The assertion is that the collaborator name dropdown only appears on the page
      # when they're assigned. So let's test the inverse first.
      find('#body-main').should_not have_content("#{@collaborator.full_name}")

      find('.assign-button').click
      page.should have_content(@collaborator.full_name)
      click_on @collaborator.full_name
    end

    scenario 'assigns user story', type: :feature, js: true do
      find('#body-main').should have_content("#{@collaborator.full_name}")
    end
  end
end
