require 'spec_helper'

feature "user clicks home button", js: true do
  background do
    create_team_with_project
    login(@owner)
    visit_project_path(@project)
    find('.terrible').click
  end

  scenario "user sees welcome message", js: true do
    find('#body-main').should have_content("Welcome to Terrible Tracker")
  end

  scenario "user sees recent activity section", js: true do
    find('#body-main').should have_content("Recent Activity")
  end

  scenario "recent activity section contains the user's teams' recent activity", js: true do
    find('#body-main').should have_content("#{@owner.full_name} created user story #{@story.title}")
  end
end
