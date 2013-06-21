require 'spec_helper'

include Warden::Test::Helpers
Warden.test_mode!

feature "user can add projects" do
  background do
    user = FactoryGirl.create(:user)
    login_as(user, :scope => :user)
    visit root_path
  end

  scenario "user sees empty project page" do
    click_link "New Project"
    fill_in "project[title]", with: "My Great Project"
    fill_in "project[description]", with: "A project just for me"
    fill_in "project[budget]", with: 10000
    fill_in "project[weekly_rate]", with: 20
    click_button "Create Project"
    expect(page).to have_content("My Great Project")
  end
end
