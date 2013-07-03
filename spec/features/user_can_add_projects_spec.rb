require 'spec_helper'

feature "user can add projects" do

  background do
    create_team_with_project
    login(@owner)
    visit_team_path(@team)
  end

  scenario "user sees empty project page", type: :feature, js: true do
    find("#new-project-btn").click
    fill_in "project[title]", with: "My Great Project"
    fill_in "project[description]", with: "A project just for me"
    fill_in "project[budget]", with: 10000
    fill_in "project[weekly_rate]", with: 20
    click_button "Create Project"
    find("#user-specific-navbar").should have_content("My Great Project")
  end
end
