require 'spec_helper'

include Warden::Test::Helpers
Warden.test_mode!

feature 'team owners can remove members', %q{
  As a team owner,
  I want to remove members,
  In case I don't want to work with them anymore.
} do

  # Acceptance Criteria:
  # Team owner visits team page, and sees team list.
  # They click "Remove Member," and that member is
  # removed from the team. No other team members have
  # member removal abilities.

  context 'as a collaborator' do
    let(:ownership)  { FactoryGirl.create(:active_team_ownership) }
    let(:membership) { FactoryGirl.create(:active_team_collaboratorship) }

    scenario 'adding a user story to a project' do
      @team = ownership.team
      @owner = ownership.user
      @collaborator = membership.user
      membership.joinable = @team
      membership.save

      login_as(@collaborator, scope: :user)
      visit team_path(@team)
      expect(page).to_not have_content("Remove Member")
      logout(@collaborator)

      login_as(@owner, scope: :user)
      visit team_path(@team)
      all('a').select {|link| link.text == "Remove Member" }.first.click

      expect(page).to have_content("Member removed")
      expect(page).to_not have_content(@collaborator.email)
      expect(@team.members.length).to eql(1)
    end
  end
end
