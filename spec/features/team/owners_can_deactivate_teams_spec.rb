require 'spec_helper'

feature 'owners can deactivate teams', %q{
  As a team owner,
  I want to be able to deactivate my team,
  so that I know longer have it in my sidebar.
} do
  # Acceptance Criteria:
  # Team owner logs in, and deactivates their team.
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
      find('#undo-team-deactivation').should have_content("Undo")
      find('#undo-team-deactivation').click
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
