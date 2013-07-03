require 'spec_helper'

feature "project page displays recent activity on creation", %q{
  As a user,
  when I create a new project, I want all team members to be made active on it,
  so I can assign them to user stories immediately.
} do
  # Acceptance Criteria:
  # User creates a new project page, and the recent activity page is
  # already active with the activity "user created project."

  context 'as a user' do

    background do
      create_team_with_project
      login(@owner)
      visit_team_path(@team)
      find("#new-project-btn").click
      fill_in "project[title]", with: "My Great Project"
      fill_in "project[description]", with: "A project just for me"
      fill_in "project[budget]", with: 10000
      fill_in "project[weekly_rate]", with: 20
      click_button "Create Project"
    end

    scenario "seeing project's activity", js: true do
      find("#user-specific-navbar").should have_content("My Great Project")
      @project2 = Project.where(title: "My Great Project", team_id: @team.id).first
      find('#project-activities-table').should have_content("#{@owner.full_name} created #{@project2.title}")
    end
  end
end
