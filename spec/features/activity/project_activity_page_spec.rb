require 'spec_helper'

feature "project page displays the project's recent activity", %q{
  As a user,
  I want to see the recent activity of my projects,
  so that I can know what's happened while I was away.
} do
  # Acceptance Criteria:
  # User visits the page for a project, and sees the recent activity
  # of that project and only that project.

  context 'as a user' do

    background do
      create_team_with_project
      login(@owner)
      visit_project_path(@project)
    end

    scenario "seeing project's activity", js: true do
      find('#body-main').should have_content("Recent Activity")
      find('#body-main').should have_content("#{@owner.full_name} created user story #{@story.title}")
    end

    scenario "only displays activity for this team", js: true do
      activity2 = FactoryGirl.create(:activity)
      find('#body-main').should_not have_content(activity2.trackable.title)
    end
  end
end
