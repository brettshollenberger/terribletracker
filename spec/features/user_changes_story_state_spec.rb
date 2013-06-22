require 'spec_helper'

include Warden::Test::Helpers
Warden.test_mode!

feature 'collaborator user story state', %q{
  As a owner or collaborator,
  I want to change the state of a user story,
  so that I can keep my teammates aware of my progress.
} do
  # Acceptance Criteria:
  # User visits a project page, and clicks the user story title to edit it.
  # The link raises the edit form; on save, the user is informed that
  # they have updated the story successfully, and they can see the updated
  # story on the projects page.

  context 'as a collaborator' do
    let(:membership) { FactoryGirl.create(:active_collaboratorship) }

    background do
      @project = membership.project
      @user = membership.user
      @story = FactoryGirl.create(:user_story)
      @story.project = @project
      @story.save
      login_as(@user, scope: :user)
      visit project_path(@project)
    end

    scenario 'starting a user story' do
      click_link "Start"
      @story.start
      expect(page).to have_content("Start")
      expect(@story.state).to eql("started")
    end
  end
end
