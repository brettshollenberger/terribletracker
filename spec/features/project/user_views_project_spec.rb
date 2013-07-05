require 'spec_helper'

feature 'users can view projects', %q{
  As a user,
  I want to view my projects,
  so that I can work on them.
} do

  # Acceptance Criteria:
  # User logs in, and clicks the project name in the sidebar,
  # they are taken to the project page, and the corresponding project
  # and team are checked in the sidebar.

  context 'as a new member' do

    background do
      create_team_with_project
      login(@owner)
      visit_project_path(@project)
    end

    scenario 'project page has an edit field for the title', type: :feature, js: true do
      find("#project_title").should have_content("")
      find_field("project[title]").value.should eq("#{@project.title}")
    end

    scenario 'project page has recent activity', type: :feature, js: true do
      find('#body-main').should have_content("Recent Activity")
      find('#body-main').should have_content("#{@owner.full_name} created user story #{@story.title}")
    end

    scenario 'project page has user stories', type: :feature, js: true do
      find('#body-main').should have_content("User Stories")
      find('#body-main').should have_content("#{@story.title}")
    end

    scenario 'project page contains new user story form by default', type: :feature, js: true do
      find('#right-sidebar').should have_content("New Story")
      find('#new_story_form')
    end
  end
end
