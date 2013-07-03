require 'spec_helper'

feature 'new projects automagically make all team members active', %q{
  As a project owner,
  When I create a project for my team, I want all team members
  to automatically be made active, so that I can work with them immediately.
} do

  # Acceptance Criteria:
  # User creates new team, and all team members are automatically
  # active on it, ready to be assigned user stories.

  context 'as a new member' do

    background do
      create_team_with_project
      login(@owner)
      visit_team_path(@team)
    end

    scenario 'creates project', type: :feature, js: true do
      find("#new-project-btn").click
      fill_in "project[title]", with: "My Great Project"
      fill_in "project[description]", with: "A project just for me"
      fill_in "project[budget]", with: 10000
      fill_in "project[weekly_rate]", with: 20
      click_button "Create Project"
      find("#user-specific-navbar").should have_content("My Great Project")
      @project2 = Project.where(title: "My Great Project", team_id: @team.id).first
      expect(@project2.users).to include(@collaborator)
      expect(@project2.users.length).to eql(2)
    end
  end
end
