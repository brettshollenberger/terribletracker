require 'spec_helper'

feature 'collaborator adds user story', %q{
  As a user
  I want to add user stories to a project and see that they are associated with it afterwards
  so that I can define the project scope.
} do
  # Acceptance Criteria:
  # user stories have a title, story, estimate (in increments of .25 days), an actual time spent, and a complexity.
  # They belong to projects and users (assigned to them).

  context 'as a collaborator' do
    let(:membership) { FactoryGirl.create(:active_collaboratorship) }

    scenario 'adding a user story to a project' do
      project = membership.project
      user = membership.user

      visit login_path
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_button 'Sign in'

      visit project_path(project)

      click_on 'Add Story'

      fill_in 'Title', with: 'New user story'
      fill_in 'user_story[story]', with: 'foo bar baz'
      fill_in 'Estimate in quarter days', with: 1
      fill_in 'Complexity', with: 1

      click_on 'Create Story'

      page.should have_content('New user story')
      page.should have_content('foo bar baz')
      page.should have_content('0.25 days')
      page.should have_content('1')
    end
  end
end
