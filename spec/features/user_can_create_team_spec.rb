require 'spec_helper'

include Warden::Test::Helpers
Warden.test_mode!

feature 'user creates team', %q{
  As a user,
  I want to create teams,
  so that I can add team members to projects.
} do
  # Acceptance Criteria:
  # user stories have a title, story, estimate (in increments of .25 days), an actual time spent, and a complexity.
  # They belong to projects and users (assigned to them).

  context 'as a collaborator' do
    let(:user) { FactoryGirl.create(:user) }

    background do
      login_as(user, scope: :user)
      visit root_path
    end

    scenario 'adding a user story to a project' do
      click_on "Create Team"

      fill_in "team[name]", with: "The Merry Men"
      fill_in "team[description]", with: "Four very funny guys that do stuff"
      click_button "Create Team"

      expect(page).to have_content("The Merry Men")
      expect(page).to have_content("Members")
      expect(page).to have_content("#{user.first_name} #{user.last_name}")
    end
  end
end
