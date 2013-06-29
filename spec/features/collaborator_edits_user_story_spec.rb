require 'spec_helper'

include Warden::Test::Helpers
Warden.test_mode!

feature 'collaborator edits user story', %q{
  As a owner or collaborator,
  I want to edit the details of a user story,
  so that I can keep the project scope up-to-date.
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
      @team = @project.team
      @user = membership.user
      @story = FactoryGirl.create(:user_story)
      @story.project = @project
      @story.save
      login_as(@user, scope: :user)
      visit root_path

      click_on @project.title
    end

    scenario 'adding a user story to a project', :js => true do
      click_on @story.title
      save_and_open_page
      fill_in 'user_story[title]', with: 'Fast Times'
      fill_in 'user_story[story]', with: 'As a student at Ridgemont High, I would like to
        enjoy fast times.'
      fill_in 'user_story[estimate_in_quarter_days]', with: 2
      fill_in 'user_story[complexity]', with: 7

      click_on 'Update Story'

      expect(page).to have_content("Story updated")

      expect(page).to have_content("Fast Times")
      expect(page).to have_content("As a student")
      expect(page).to have_content(".5 days")
      expect(page).to have_content("7")

      expect(page).to_not have_content('New user story')
      expect(page).to_not have_content('foo bar baz')
      expect(page).to_not have_content('0.25 days')
      expect(page).to_not have_content('Complexity: 1')
    end
  end
end
