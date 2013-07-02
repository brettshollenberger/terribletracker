require 'spec_helper'

include Warden::Test::Helpers
Warden.test_mode!

feature 'collaborator comments on user story', %q{
  As a collaborator,
  I want to comment on user stories,
  so that I can weigh in or help out.
} do
  # Acceptance Criteria:
  # User visits a project page, and clicks the user story title to edit it.
  # The link raises the edit form, and a comment form beneath.
  # The user makes their comment, which then shows up on the user story's
  # Right navbar.

  context 'as a collaborator' do
    let(:membership) { FactoryGirl.create(:active_collaboratorship) }
    let(:story)      { FactoryGirl.create(:user_story) }
    let(:comment)    { FactoryGirl.create(:comment) }

    background do
      @project = membership.project
      @team = @project.team
      @user = membership.user
      story.project = @project
      story.save
      login_as(@user, scope: :user)
      visit project_path(@project)
    end

    scenario 'commenting on a user story', js: true do
      click_on story.title
      fill_in "Comment", with: comment.body
      click_on "Comment"
      expect(page).to have_content('Cool dog')
    end
  end
end
