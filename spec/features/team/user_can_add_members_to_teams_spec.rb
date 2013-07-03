require 'spec_helper'

feature 'user adds member to team', %q{
  As a user,
  I want to create teams,
  so that I can add team members to projects.
} do

  # Acceptance Criteria:
  # User visits team page, and clicks on "Invite Collaborator."
  # They enter the name of the user they want to invite, and
  # are alerted that the user has been invited.

  context 'as a collaborator' do
    let(:new_member) { FactoryGirl.create(:user) }

    background do
      create_team_with_project
      login(@owner)
      visit_team_path(@team)
    end

    scenario 'adding a member to a team', type: :feature, js: true do
      click_on "Invite Collaborator"
      fill_in "membership[user]", with: new_member.email
      click_button "Add Member"

      expect(page).to have_content("Member invited")
    end
  end
end
