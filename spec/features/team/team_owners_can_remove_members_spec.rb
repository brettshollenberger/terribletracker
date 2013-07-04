require 'spec_helper'

feature 'team owners can remove members', %q{
  As a team owner,
  I want to remove members,
  In case I don't want to work with them anymore.
} do

  # Acceptance Criteria:
  # Team owner visits team page, and sees team list.
  # They click "Remove Member," and that member is
  # removed from the team. No other team members have
  # member removal abilities.

  context 'as a collaborator' do
    background do
      create_team_with_project
    end

    scenario 'collaborators cannot remove one another', type: :feature, js: true do
      login(@collaborator)
      visit_team_path(@team)
      expect(page).to_not have_content("Remove Member")
      logout
    end

    scenario 'owners can remove anyone', type: :feature, js: true do
      login(@owner)
      visit_team_path(@team)
      find('.remove-member-link').click
      expect(page).to_not have_content(@collaborator.email)
    end

    scenario 'removed members are no longer active on team projects', type: :feature, js: true do
      login(@owner)
      visit_team_path(@team)
      find('.remove-member-link').click
      visit_project_path(@project)
      find('.assign-button').click
      page.should_not have_content(@collaborator.full_name)
    end
  end
end
