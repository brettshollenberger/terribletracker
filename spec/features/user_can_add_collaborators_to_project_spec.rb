require 'spec_helper'

include Warden::Test::Helpers
Warden.test_mode!

feature "user can add collaborators to project", %q{
  As a user,
  I would like to add collaborators to my projects,
  so that I can get my whole team working together.
} do

  # Acceptance Criteria:
  # User visits project, and clicks "Add Collaborator."
  # User fills in the collaborators' email (who already has an account),
  # and clicks "Add Collaborator."
  # The collaborator is sent a project invitation, and can
  # login to accept or decline.

  background do
    @membership = FactoryGirl.create(:active_ownership)
    @project = @membership.project
    @user = @project.owner
    @user2 = FactoryGirl.create(:user)
  end

  scenario "user is not a collaborator" do
    login_as(@user2, :scope => :user)
    visit projects_path
    expect(page).to_not have_content(@project.title)
  end

  scenario "user is added as a collaborator by the project's owner" do
    login_as(@user, :scope => :user)
    visit project_path(@project)
    click_link "Add Collaborator"
    fill_in "membership[user]", with: @user2.email
    click_button "Add Collaborator"
    expect(page).to have_content("Collaborator Added")
    logout(@user)
    login_as(@user2, :scope => :user)
    expect(page).to have_content(@project.title)
  end

  scenario "user is already active on a project" do
    login_as(@user, :scope => :user)
    visit project_path(@project)
    click_link "Add Collaborator"
    fill_in "membership[user]", with: @user.email
    click_button "Add Collaborator"
    expect(page).to have_content("already active on this project")
  end

  scenario "user has already been invited to the project" do
    login_as(@user, :scope => :user)
    visit project_path(@project)
    2.times do
      click_link "Add Collaborator"
      fill_in "membership[user]", with: @user2.email
      click_button "Add Collaborator"
    end
    expect(page).to have_content("has already been invited to this project")
  end
end
