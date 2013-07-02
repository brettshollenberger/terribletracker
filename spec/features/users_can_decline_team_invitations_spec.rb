require 'spec_helper'

include Warden::Test::Helpers
Warden.test_mode!

feature 'collaborators and clients can decline team invitations', %q{
  As a collaborator or client,
  I would like to decline my team invitations,
  so that I don't have to see them anymore.
} do
  # Acceptance Criteria:
  # User visits their homepage, and sees that they have a team invitation.
  # They click the decline button, and the team is removed from their view.

  context 'as a collaborator' do
    background do
      @active_team_ownership = FactoryGirl.create(:active_team_ownership)
      @active_owner = @active_team_ownership.user
      @team = @active_team_ownership.team
      @pending_collaboratorship = FactoryGirl.create(:pending_team_membership, joinable: @team)
      @pending_collaborator = @pending_collaboratorship.user

      login(@pending_collaborator)
    end

    scenario 'accepting invitations', type: :feature, js: true do
      find('.dropdown-toggle').click
      find('.decline-invitation').should have_content("Decline")
      find('.decline-invitation').click
      find('#user-specific-navbar').should_not have_content(@team.name)
    end
  end
end
