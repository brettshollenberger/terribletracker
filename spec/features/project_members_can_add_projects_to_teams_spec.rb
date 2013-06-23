require 'spec_helper'

include Warden::Test::Helpers
Warden.test_mode!

feature 'project members can add their projects to teams', %q{
  As a project member,
  I want to add my project to a team,
  So that the team can collaborate more easily.
} do

  # Acceptance Criteria:
  # Project member visits project page, and sees option to add
  # it to one of their teams. They do so, and it appears
  # on the team's page.

  context 'as a collaborator' do
    let(:ownership)  { FactoryGirl.create(:active_ownership) }

    scenario 'adding a user story to a project' do
      @project = ownership.project
      @owner = ownership.user
      @team_ownership = FactoryGirl.create(:active_team_ownership)
      @team_ownership.user = @owner
      @team_ownership.save
      @team_ownership.reload
      @team = @team_ownership.team

      login_as(@owner, scope: :user)
      visit project_path(@project)

      click_on "Add to Team"

      fill_in "project[team]", with: @team.name

      expect(page).to have_content(@team.name)
      visit team_path(@team)
      expect(page).to have_content(@project.title)
    end
  end
end
