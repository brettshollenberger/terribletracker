require 'spec_helper'

include Warden::Test::Helpers
Warden.test_mode!

feature 'collaborators can assign themselves and others to user stories', %q{
  As a project collaborator,
  I would like to assign myself and my teammates to user stories,
  so that we can get to work.
} do

  # Acceptance Criteria:
  # User visits project page with user stories on it.
  # They click a dropdown to select a teammate to assign
  # as user story to.

  context 'as a new member' do

    background do
      @user_story = FactoryGirl.create(:user_story)
      @project = @user_story.project
      @user = FactoryGirl.create(:user)
      @user2 = FactoryGirl.create(:user)
      users = [@user, @user2]
      users.each { |user| Membership.create(user: user, joinable: @project, role: "collaborator", state: "active") }
      users.each { |user| user.reload }

      login_as(@user, scope: :user)
      visit project_path(@project)
      click_link @user2.decorate.full_name
    end

    scenario 'assigns user story' do
      expect(page).to have_content("#{@user2.decorate.full_name} assigned")
    end
  end
end
