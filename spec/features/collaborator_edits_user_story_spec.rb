srequire 'spec_helper'

include Warden::Test::Helpers
Warden.test_mode!

feature 'collaborator edits user story', %q{
  As a owner or collaborator,
  I want to edit the details of a user story,
  so that I can keep the project scope up-to-date.
} do
  # Acceptance Criteria:
  # User visits a project page, and clicks the user story title to edit it.
  # The link raises the edit form; on save, the user is informed that
  # they have updated the story successfully, and they can see the updated
  # story on the projects page.

  context 'as a collaborator', js: true do
    let(:membership) { FactoryGirl.create(:active_team_collaboratorship) }

    background do
      @ownership = FactoryGirl.create(:active_team_ownership)
      @team = @ownership.joinable
      @project = FactoryGirl.create(:project, team: @team)
      @owner = @team.owner
      @user_story = FactoryGirl.create(:user_story, project: @project)

      login(@owner)
    end

    scenario 'adding a user story to a project', :js => true do
      find("#team_name_#{@team.id}").click
      find("#project_title_#{@project.id}").click
      find("#user_story_link_#{@user_story.id}").click
      fill_in 'user_story[title]', with: 'Fast Times'
      fill_in 'user_story[story]', with: 'As a student at Ridgemont High, I would like to
        enjoy fast times.'

      # Simulate form submission
      keypress_script = "$('#edit_story_form').submit();"
      page.driver.execute_script(keypress_script)

      find('#body-main').should have_content("Fast Times")
      find("#user_story_link_#{@user_story.id}").click
      find('#user_story_story').should have_content("As a student")
    end
  end
end
