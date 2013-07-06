require 'spec_helper'

feature 'two users can create teams with the same name', %q{
  As a user,
  I want to create a team,
  and not worry about whether or not someone else
  has already taken my team name.
} do
  # Acceptance Criteria:
  # Users can create teams, and other users can create teams with the same name.

  context 'as a collaborator' do
    let(:user)  { FactoryGirl.create(:user) }
    let(:user2) { FactoryGirl.create(:user) }

    background do
      login(user)
    end

    scenario 'adding a new team with a taken name', type: :feature, js: true do
      find('#new-team-btn').click
      fill_in "team[name]", with: "The Merry Men"

      # Simulate form submission
      press_enter("#new_team")

      find('#members-header').should have_content("Members")
      logout

      login(user2)

      find('#new-team-btn').click
      fill_in "team[name]", with: "The Merry Men"

      # Simulate form submission
      press_enter("#new_team")

      find('#members-header').should have_content("Members")
    end

    scenario 'one user cannot own two teams with the same name', type: :feature, js: true do
      find('#new-team-btn').click
      fill_in "team[name]", with: "The Merry Men"

      # Simulate form submission
      press_enter("#new_team")

      find('#members-header').should have_content("Members")

      find('.terrible').click
      find('#new-team-btn').click
      fill_in "team[name]", with: "The Merry Men"

      # Simulate form submission
      press_enter("#new_team")

      find('#new_team_errors').should have_content("You cannot have two teams with the same name")
    end
  end
end
