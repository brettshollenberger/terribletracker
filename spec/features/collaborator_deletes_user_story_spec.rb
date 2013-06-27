require 'spec_helper'

include Warden::Test::Helpers
Warden.test_mode!

feature 'collaborator deletes user story', %q{
  As a owner or collaborator,
  I want to delete user stories,
  so that I can keep the project scope up-to-date.
} do
  # Acceptance Criteria:
  # User visits a project page, and clicks the user story title to edit it.
  # The link raises the edit form; on save, the user is informed that
  # they have updated the story successfully, and they can see the updated
  # story on the project page.

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

    scenario 'adding a user story to a project' do
      expect(page).to have_content('Terrible Story')
      expect(page).to have_content('As a user, I want to take over the world, so I can be its sole leader.')
      expect(page).to have_content('0.25 days')

      click_on "Delete"

      expect(page).to_not have_content('Terrible Story')
      expect(page).to_not have_content('As a user, I want to take over the world, so I can be its sole leader.')
      expect(page).to_not have_content('0.25 days')
    end
  end
end
