require 'spec_helper'

feature 'user sees recent activity', %q{
  As a user,
  I want to see the recent activity of my teams,
  so that I can know what's happened while I was away.
} do
  # Acceptance Criteria:
  # User visits the homepage, and sees the recent activity
  # of their teams.

  context 'as a user' do

    background do
      create_team_with_project
      login(@owner)
    end

    scenario 'seeing recent activity', js: true do
      find('#body-main').should have_content("Recent Activity")
      find('#body-main').should have_content("#{@owner.full_name} created user story #{@story.title}")
    end
  end
end
