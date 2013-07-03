require 'spec_helper'

include Warden::Test::Helpers
Warden.test_mode!

feature 'collaborator user story state', %q{
  As a owner or collaborator,
  I want to change the state of a user story,
  so that I can keep my teammates aware of my progress.
} do
  # Acceptance Criteria:
  # User visits a project page, and clicks the user story title to edit it.
  # The link raises the edit form; on save, the user is informed that
  # they have updated the story successfully, and they can see the updated
  # story on the projects page.

  context 'as a collaborator' do
    let(:ownership) { FactoryGirl.create(:active_team_ownership) }

    background do
      @owner = ownership.user
      @team = ownership.team
      @project = FactoryGirl.create(:project, team: @team)
      @story = FactoryGirl.create(:user_story, project: @project)
      login(@owner)
      visit_project_path(@project)
    end

    scenario 'starting a user story', type: :feature, js: true do
      find('.state-btn').should have_content("Unstarted")
      find('.state-btn').should_not have_content("Started")
      find('.state-btn').click
      find('.dropdown-menu').should have_content("Started")
      find('.started-btn').click
      find('.started-dropdown').should have_content("Started")
      find('.started-dropdown').should_not have_content("Unstarted")
    end
  end
end
