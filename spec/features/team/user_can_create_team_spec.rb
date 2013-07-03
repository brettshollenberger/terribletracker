require 'spec_helper'

feature 'user creates team', %q{
  As a user,
  I want to create teams,
  so that I can add team members to projects.
} do
  # Acceptance Criteria:
  # Users can create teams, and then see them.

  context 'as a collaborator' do
    let(:user) { FactoryGirl.create(:user) }

    background do
      login(user)
    end

    scenario 'adding a user story to a project', type: :feature, js: true do
      find('#new-team-btn').click
      fill_in "team[name]", with: "The Merry Men"

      # Simulate form submission
      press_enter("#new_team")

      find('#members-header').should have_content("Members")
      find('#body-main').should have_content("#{user.first_name} #{user.last_name}")
      find('#user-specific-navbar').should have_content("The Merry Men")
    end
  end
end
