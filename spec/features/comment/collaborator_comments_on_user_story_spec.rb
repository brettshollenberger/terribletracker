require 'spec_helper'

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

  context 'as an owner' do

    background do
      create_team_with_project
      login(@owner)
      visit_project_path(@project)
    end

    scenario 'commenting on a user story', js: true do
      click_on @story.title
      fill_in "Comment", with: @comment.body
      click_on "Comment"
      expect(page).to have_content('Cool dog')
    end
  end
end
