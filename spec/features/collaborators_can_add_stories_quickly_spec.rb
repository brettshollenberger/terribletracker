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
    let(:membership) { FactoryGirl.create(:active_ownership) }

    scenario 'adding a user story to a project', :js => true do
      project = membership.project
      user = membership.user
      team = project.team

      login_as(user, scope: :user)

      visit root_path
      click_on project.title

      expect(page).to have_content(project.title)
      expect(page).to have_content(project.budget)

      fill_in 'Title', with: 'User can add user stories on the same page'
      fill_in 'user_story[story]', with: 'As a user, I would like to continue entering user stories from the projects page'
      fill_in 'Estimate in quarter days', with: 2
      fill_in 'Complexity', with: 7

      click_on 'Create Story'

      page.should have_content('User can add user stories on the same page')
      page.should have_content('As a user, I would like to continue entering user stories from the projects page')
      page.should have_content('0.5 days')
      page.should have_content('7')
    end
  end
end
