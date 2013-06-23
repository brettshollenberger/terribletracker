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
    let(:ownership)        { FactoryGirl.create(:active_team_ownership) }
    let(:new_collaborator) { FactoryGirl.create(:user) }

    background do
      @owner = ownership.user
      @team = ownership.team
      login_as(@owner, scope: :user)
      visit team_path(@team)
      click_link "Add Team Member"
      fill_in "User's Email", with: new_collaborator.email
      click_button "Add Member"
      logout(@owner)
      login_as(new_collaborator, scope: :user)
      visit root_path
    end

    scenario 'declining invitations' do
      click_link "Decline"

      expect(page).to have_content("You've declined")
      expect(page).to_not have_content(@team.name)
    end
  end
end
