require 'spec_helper'

feature 'removed team members are automatically removed from team projects and user stories', %q{
  As a team owner,
  I want to remove a team member from all team projects with one click,
  so I can be sure they're no longer working with my team.
} do

  # Acceptance Criteria:
  # Team owner visits the team page.
  # They click remove member.
  # That member is no longer active on team projects, and their
  # user stories no longer have an owner.

  context 'as a team owner' do

    background do
      create_team_with_project
      login(@owner)
      visit_team_path(@team)
    end

    scenario "remove a team member", type: :feature, js: true do
      find(".team-members-table").should have_content(@collaborator.full_name)
      find(".remove-member-link").click
      find(".team-members-table").should_not have_content(@collaborator.full_name)
      logout

      login(@collaborator)
      expect(page).to_not have_content(@team.name)
    end
  end
end
