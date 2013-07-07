require 'spec_helper'

feature 'users can deactivate projects', %q{
  As a user,
  I want to be able to deactivate a project when I am
  done with it, so I can remove my screen from clutter.
} do
  # Acceptance Criteria:
  # User logs in, and clicks the deactivate project button;
  # it no longer shows up, but it does offer for them
  # to undo their last action.

  context 'as an owner' do

    background do
      create_team_with_project
      login(@owner)
      visit_project_path(@project)
      find("#project-destroy-icon-#{@project.id}").click
    end

    scenario 'removing project', type: :feature, js: true do
      find('#user-specific-navbar').should_not have_content(@project_title)
    end

    scenario "undoing project deactivation", type: :feature, js: :true do
      find('#undo-project-deactivation').should have_content("Undo")
      find('#undo-project-deactivation').click
      find('#user-specific-navbar').should have_content(@project_title)
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


