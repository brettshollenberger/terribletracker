require 'spec_helper'

feature 'users can delete projects', %q{
  As a user,
  I want to be able to delete a project when I am
  done with it, so I can remove my screen from clutter.
} do
  # Acceptance Criteria:
  # User logs in, and clicks the destroy project button;
  # it no longer shows up, but it does offer for them
  # to undo their last action.

  context 'as an owner' do

    background do
      create_team_with_project
    end

    scenario 'removing project', type: :feature, js: true do
      login(@owner)
      visit_project_path(@project)
      find("#project-destroy-icon-#{@project.id}").click
      find('#user-specific-navbar').should_not have_content(@project_title)
    end
  end

  context 'as a collaborator' do

    background do
      create_team_with_project
    end

    scenario 'removing project', type: :feature, js: true do
      login(@collaborator)
      visit_project_path(@project)
      find("#project-destroy-icon-#{@project.id}").click
      find('#user-specific-navbar').should_not have_content(@project_title)
    end
  end
end

