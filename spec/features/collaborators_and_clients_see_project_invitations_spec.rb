require 'spec_helper'

include Warden::Test::Helpers
Warden.test_mode!

feature 'collaborators and clients can see their project invitations', %q{
  As a collaborator or client,
  I would like to see the projects I am invited to,
  so that I can decide whether or not to join them.
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

    scenario 'seeing invitations' do
      expect(page).to have_content("Invitations")
      expect(page).to have_content(@project.owner.decorate.full_name)
      expect(page).to have_content("My Awesome Project")
      expect(page).to have_content("Accept")
      expect(page).to have_content("Decline")
    end
  end
end
