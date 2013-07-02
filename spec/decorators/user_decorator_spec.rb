require 'spec_helper'

describe UserDecorator do
  before :each do
    @active_team_ownership = FactoryGirl.create(:active_team_ownership)
    @team = @active_team_ownership.team
    @project = FactoryGirl.create(:project, team: @team)
    @owner = @active_team_ownership.user.decorate
    @project_ownership = FactoryGirl.create(:active_ownership, joinable: @project, user: @owner)
    @active_team_collaboratorship = FactoryGirl.create(:active_team_collaboratorship, joinable: @team)
    @collaborator = @active_team_collaboratorship.user.decorate
    @pending_team_membership = FactoryGirl.create(:pending_team_membership, joinable: @team)
    @pending_member = @pending_team_membership.user.decorate
    @pending_collaboratorship = FactoryGirl.create(:pending_collaboratorship, joinable: @project, user: @pending_member)
    @active_clientship = FactoryGirl.create(:active_clientship, joinable_id: @team.id, joinable_type: "Team")
    @client = @active_clientship.user.decorate
    @activity = FactoryGirl.create(:activity, team: @team)
  end

  describe "active_projects" do
    it "returns the user's active projects" do
      expect(@owner.active_projects).to include(@project)
    end
  end

  describe "project_invitations" do
    it "returns the user's pending project memberships" do
      expect(@pending_member.project_invitations).to include(@pending_collaboratorship)
    end
  end

  describe "active_teams" do
    it "returns the user's active teams" do
      expect(@owner.active_teams).to include(@team)
    end
  end

  describe "team_invitations" do
    it "returns the user's pending team memberships" do
      expect(@pending_member.team_invitations).to include(@pending_team_membership)
    end
  end

  describe "gravatar" do
    it "returns an img_tag wrapped in a link containing the user's gravatar" do
      expect(@owner.gravatar).to include("<a href=\"https://en.gravatar.com/emails/\"><img alt=\"")
    end
  end

  describe "gravatar_small" do
    it "returns an img_tag containing the user's gravatar" do
      expect(@owner.gravatar_small).to include("<img alt=\"")
    end
  end

  describe "full_name" do
    it "returns the user's full name as a string" do
      expect(@owner.full_name).to eql("#{@owner.first_name} #{@owner.last_name}")
    end
  end

end
