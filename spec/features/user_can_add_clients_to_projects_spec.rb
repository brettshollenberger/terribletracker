require 'spec_helper'

include Warden::Test::Helpers
Warden.test_mode!

feature "user can add clients to project" do
  background do
    @membership = FactoryGirl.create(:active_owner)
    @project = @membership.project
    @user = @project.owner
    @user2 = FactoryGirl.create(:user)
    login_as(@user, :scope => :user)
    visit project_path(@project)
  end

  scenario "user adds a collaborator" do
    click_link "Add Collaborator"
    fill_in "membership[user]", with: @user2.email
    click_button "Add Collaborator"
    expect(page).to have_content("Collaborator Added")
    logout(@user)
    login_as(@user2, :scope => :user)
    expect(page).to have_content(@project.title)
  end

  scenario "user is already active on a project" do
    click_link "Add Collaborator"
    fill_in "membership[user]", with: @user.email
    click_button "Add Collaborator"
    expect(page).to have_content("already active on this project")
  end

  scenario "user has already been invited to the project" do
    2.times do
      click_link "Add Collaborator"
      fill_in "membership[user]", with: @user2.email
      click_button "Add Collaborator"
    end
    expect(page).to have_content("has already been invited to this project")
  end
end
