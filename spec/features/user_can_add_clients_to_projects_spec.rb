# Reimplement feature via js

# require 'spec_helper'

# include Warden::Test::Helpers
# Warden.test_mode!

# feature "user can add clients to project", %q{
#   As a collaborator,
#   I would like to add clients to my projects,
#   so that I can keep them informed on our progress.
# } do

#   # Acceptance Criteria:
#   # User visits project, and clicks "Add Client."
#   # User fills in the clients' email (who already has an account),
#   # and clicks "Add Client."
#   # The client is sent a project invitation, and can
#   # login to accept or decline.

#   background do
#     @membership = FactoryGirl.create(:active_ownership)
#     @project = @membership.project
#     @user = @project.owner
#     @user2 = FactoryGirl.create(:user)
#     login_as(@user, :scope => :user)
#     visit project_path(@project)
#   end

#   scenario "user adds a client" do
#     click_link "Add Client"
#     fill_in "membership[user]", with: @user2.email
#     click_button "Add Client"
#     expect(page).to have_content("Client Added")
#     logout(@user)
#     login_as(@user2, :scope => :user)
#     expect(page).to have_content(@project.title)
#   end

# end
