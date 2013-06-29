require 'spec_helper'

include Warden::Test::Helpers
Warden.test_mode!

feature 'collaborators and clients can decline their project invitations', %q{
  As a collaborator or client,
  I would like to decline my invitations,
  so that I don't have to see projects I don't want to work on.
} do
  # Acceptance Criteria:
  # User visits their homepage, and sees their project invitations.
  # User clicks decline, and the project is removed from their view.

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

    scenario 'declining invitations' do
      click_link "Decline"

      expect(page).to have_content("You've declined")
      expect(page).to_not have_content(@project.title)
    end
  end
end
