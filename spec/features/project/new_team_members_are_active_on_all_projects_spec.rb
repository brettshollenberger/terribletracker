require 'spec_helper'

feature 'new team members are automatically added to all projects', %q{
  As a new team member,
  I want to automatically be added to the teams' projects,
  so I can get started right away.
} do

  # Acceptance Criteria:
  # New team member accepts team invitation,
  # and is automatically added to all projects. They can
  # view the teams' projects on the team page, and in their nav.

  context 'as a new member' do
    let(:pending_membership) { FactoryGirl.create(:pending_team_membership, joinable: @team, inviter: @collaborator) }
    let(:pending_member)     { pending_membership.user }

    background do
      create_team_with_project
      pending_membership.inviter_id = @owner.id

      login(pending_member)
    end

    scenario 'accepts invitation', type: :feature, js: true do
      find('.dropdown-toggle').click
      find('.accept-invitation').should have_content("Accept")
      find('.accept-invitation').click
      find('#user-specific-navbar').should have_content(@team.name)
    end
  end
end
