require 'spec_helper'

include Warden::Test::Helpers
Warden.test_mode!

feature 'user adds member to team', %q{
  As a user,
  I want to create teams,
  so that I can add team members to projects.
} do

  # Acceptance Criteria:
  # User visits team page, and

  context 'as a collaborator' do
    let(:team_ownership) { FactoryGirl.create(:active_team_ownership) }
    let(:team)           { team_ownership.team }
    let(:owner)          { team.owner }
    let(:new_member)     { FactoryGirl.create(:user) }

    background do
      login_as(owner, scope: :user)
      visit root_path

      visit team_path(team)
    end

    scenario 'adding a member to a team' do
      click_on "Add Team Member"
      fill_in "membership[user]", with: new_member.email
      click_button "Add Member"

      expect(page).to have_content("Member invited")
    end
  end
end
