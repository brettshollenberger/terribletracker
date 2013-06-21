require 'spec_helper'

include Warden::Test::Helpers
Warden.test_mode!

feature "user can add collaborators to project" do
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
end
