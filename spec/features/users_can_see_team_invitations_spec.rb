require 'spec_helper'

include Warden::Test::Helpers
Warden.test_mode!

feature 'collaborators and clients can accept team invitations', %q{
  As a collaborator or client,
  I would like to accept my team invitations,
  so that I can join teams.
} do
  # Acceptance Criteria:
  # User visits their homepage, and sees that they have a team invitation.
  # They click the accept button, and the team is added to their
  # teams list in their navbar.

  context 'as a collaborator' do
    background do
      @active_team_ownership = FactoryGirl.create(:active_team_ownership)
      @active_owner = @active_team_ownership.user.decorate
      @team = @active_team_ownership.team
      @active_collaboratorship = FactoryGirl.create(:active_team_membership, joinable: @team)
      @active_collaborator = @active_collaboratorship.user.decorate
      @pending_collaboratorship = FactoryGirl.create(:pending_team_membership, joinable: @team, inviter: @active_collaborator)
      @pending_collaborator = @pending_collaboratorship.user.decorate

      login(@pending_collaborator)
    end

    scenario 'seeing invitations', type: :feature, js: true do
      find('#body-main').should have_content(@team.name)
      find('#body-main').should have_content(@active_owner.full_name)
      find('#body-main').should have_content(@active_collaborator.full_name)
      find('.dropdown-toggle').click
      find('.accept-invitation').should have_content("Accept")
      find('.decline-invitation').should have_content("Decline")
      find('#user-specific-navbar').should_not have_content(@team.name)
    end
  end
end
