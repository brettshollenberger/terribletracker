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
    let(:ownership)        { FactoryGirl.create(:active_team_ownership) }
    let(:collaboratorship) { FactoryGirl.create(:active_team_collaboratorship) }
    let(:new_collaborator) { FactoryGirl.create(:user) }

    background do
      @owner = ownership.user
      @team = ownership.team
      collaboratorship.joinable = @team
      collaboratorship.save
      @collaborator = collaboratorship.user
      login_as(@collaborator, scope: :user)
      visit team_path(@team)
      click_link "Add Team Member"
      fill_in "User's Email", with: new_collaborator.email
      click_button "Add Member"
      logout(@collaborator)
      login_as(new_collaborator, scope: :user)
      visit root_path
    end

    scenario 'seeing invitations' do
      expect(page).to have_content(@team.name)
      expect(page).to have_content(@owner.decorate.full_name)
      expect(page).to have_content(@collaborator.decorate.full_name)
      expect(page).to have_content("Accept")
      expect(page).to have_content("Decline")
    end
  end
end
