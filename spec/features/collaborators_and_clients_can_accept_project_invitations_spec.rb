require 'spec_helper'

include Warden::Test::Helpers
Warden.test_mode!

feature 'collaborators and clients can accept project invitations', %q{
  As a collaborator or client,
  I would like to accept my invitations,
  so that I can join projects.
} do
  # Acceptance Criteria:
  # User visits their homepage, and sees that they have an invitation.
  # They click the accept button, and the project is added to their
  # projects list on their homepage and in their navbar.

  context 'as a collaborator' do
    let(:ownership)        { FactoryGirl.create(:active_ownership) }
    let(:collaboratorship) { FactoryGirl.create(:pending_collaboratorship) }

    background do
      @owner = ownership.user
      collaboratorship.inviter_id = @owner.id
      collaboratorship.joinable = ownership.project
      collaboratorship.save
      collaboratorship.reload
      @collaborator = collaboratorship.user.decorate
      @project = collaboratorship.joinable

      login_as(@collaborator, scope: :user)
      visit root_path
    end

    scenario 'accepting invitations' do
      click_link "Accept"

      expect(page).to have_content("You're a collaborator!")
      expect(page).to have_content(@project.title)
    end
  end
end
