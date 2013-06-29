require 'spec_helper'

include Warden::Test::Helpers
Warden.test_mode!

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
    let(:ownership)        { FactoryGirl.create(:active_team_ownership) }
    let(:collaboratorship) { FactoryGirl.create(:pending_team_membership) }
    let(:project)          { FactoryGirl.create(:project) }

    background do
      @owner = ownership.user
      collaboratorship.inviter_id = @owner.id
      collaboratorship.joinable = ownership.team
      collaboratorship.save
      collaboratorship.reload
      @collaborator = collaboratorship.user.decorate
      @team = collaboratorship.joinable
      project.team = @team
      project.save
      project.reload

      login_as(@collaborator, scope: :user)
      visit root_path
    end

    scenario 'accepts invitation' do
      click_link "Accept"

      expect(page).to have_content("You're a collaborator!")
      expect(page).to have_content(@team.name)
      expect(page).to have_content(project.title)
    end
  end
end
