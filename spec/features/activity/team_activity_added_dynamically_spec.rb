require 'spec_helper'

feature "team page displays activity dynamically", %q{
  As a user,
  I want to see my new activity added to the team page
  as I complete it, so that I can be sure I've made the change.
} do
  # Acceptance Criteria:
  # User creates team, and on the loaded team page, the page already
  # contains the activity "User created Team"

  context 'as a user' do

    background do
      create_team_with_project
      login(@owner)
    end

    scenario "creating a team", js: true do
      find('#new_team_link').should have_content("New Team")
      find('#new-team-btn').click
      fill_in "team[name]", with: "The Merry Men"

      # Simulate form submission
      press_enter("#new_team")

      find('#team-activities-table').should have_content("#{@owner.full_name} created The Merry Men.")
      find('#team-activities-table').should_not have_content("No activities to show yet.")
    end

  end
end
