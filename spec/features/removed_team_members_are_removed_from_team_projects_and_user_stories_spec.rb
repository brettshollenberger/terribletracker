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
    let(:ownership)        { FactoryGirl.create(:active_team_ownership) }
    let(:collaboratorship) { FactoryGirl.create(:active_team_membership) }
    let(:project)          { FactoryGirl.create(:project) }

    background do
      @owner = ownership.user
      collaboratorship.inviter_id = @owner.id
      collaboratorship.joinable = ownership.team
      collaboratorship.save
      collaboratorship.reload
      @collaborator = collaboratorship.user.decorate
      @team = collaboratorship.joinable
      project.team = @team
      project.save
      project.reload
      login(@owner)
    end

    scenario "remove a team member", type: :feature, js: true do
      visit_team_path(@team)
      find(".team-members-table").should have_content(@collaborator.full_name)
      find(".remove-member-link").click
      find(".team-members-table").should_not have_content(@collaborator.full_name)
      find("#logout-btn").click
      login(@collaborator)
      expect(page).to_not have_content(project.title)
    end
  end
end
