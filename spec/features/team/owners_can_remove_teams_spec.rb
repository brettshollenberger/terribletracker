require 'spec_helper'

feature 'owners can delete teams', %q{
  As a team owner,
  I want to be able to delete my team,
  so that I can get out of Terrible Tracker once
  and for all!
} do
  # Acceptance Criteria:
  # Team owner logs in, and removes their team.
  # It no longer shows up, but does offer them to undo their last
  # action.

  context 'as an owner' do

    background do
      create_team_with_project
      login(@owner)
      visit_team_path(@team)
      find('.x-icon').click
    end

    scenario 'removing team', type: :feature, js: true do
      find('#user-specific-navbar').should_not have_content(@team_name)
    end

    scenario "undoing team deletion", type: :feature, js: :true do
      find('#undo-team-deletion').should have_content("Undo")
      find('#undo-team-deletion').click
      find('#user-specific-navbar').should have_content(@team_name)
    end
  end

  context 'as a collaborator' do

    background do
      create_team_with_project
    end

    scenario 'cannot remove team', type: :feature, js: true do
      login(@collaborator)
      visit_team_path(@team)
      expect(page).to_not have_selector('.x-icon')
    end
  end
end
