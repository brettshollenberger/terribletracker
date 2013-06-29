require 'spec_helper'

include Warden::Test::Helpers
Warden.test_mode!

feature 'removed team members are automatically removed from team projects and user stories', %q{
  As a team owner,
  I want to remove a team member from all team projects with one click,
  so I can be sure they're no longer working with my team.
} do

  # Acceptance Criteria:
  # Team owner visits the team page.
  # They click remove member.
  # That member is no longer active on team projects, and their
  # user stories no longer have an owner.

  context 'as a team owner' do

    background do
      @ownership = FactoryGirl.create(:active_team_ownership)
      @project_ownership = FactoryGirl.create(:active_ownership)
      @active_collaborator = FactoryGirl.create(:active_team_collaboratorship)
      @owner = @ownership.user
      @team = @ownership.team
      @project = @project_ownership.project
      @project_ownership.user = @owner
      @project_ownership.save
      @project_ownership.reload

# Finish spec
#       login_as(@owner, scope: :user)
#       visit team_path(@team)
#       click_link "Add Team Member"
#       fill_in "User's Email", with: @new_collaborator.email
#       click_button "Add Member"
#       logout(@owner)

#       login_as(@new_collaborator, scope: :user)
#       visit root_path
#     end

#     scenario 'accepts invitation' do

#       click_link "Accept"

#       expect(page).to have_content("You're a collaborator!")
#       expect(page).to have_content(@team.name)
#       expect(page).to have_content(@project.title)
#     end
#   end
# end
