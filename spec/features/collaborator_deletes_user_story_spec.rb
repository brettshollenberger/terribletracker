require 'spec_helper'

include Warden::Test::Helpers
Warden.test_mode!

feature 'collaborator deletes user story', %q{
  As a owner or collaborator,
  I want to delete user stories,
  so that I can keep the project scope up-to-date.
} do
  # Acceptance Criteria:
  # User visits a project page, and clicks the user story title to edit it.
  # The link raises the edit form; on save, the user is informed that
  # they have updated the story successfully, and they can see the updated
  # story on the project page.

  context 'as a collaborator', js: true do

    background do
      @ownership = FactoryGirl.create(:active_team_ownership)
      @team = @ownership.joinable
      @project = FactoryGirl.create(:project, team: @team)
      @owner = @team.owner
      @user_story = FactoryGirl.create(:user_story, project: @project)

      login(@owner)
    end

    scenario 'adding a user story to a project', js: true do
      visit_project_page(@team, @project)

      find("#body-main").should have_content(@user_story.title)

      click_on "Delete"

      find("#body-main").should_not have_content(@user_story.title)
    end
  end
end
