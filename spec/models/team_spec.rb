require 'spec_helper'

describe Team do
  let(:active_team_ownership)        { FactoryGirl.create(:active_team_ownership) }
  let(:team)                         { active_team_ownership.team }
  let(:project)                      { FactoryGirl.create(:project, team: team) }
  let(:owner)                        { active_team_ownership.user }
  let(:active_team_collaboratorship) { FactoryGirl.create(:active_team_collaboratorship, joinable: team) }
  let(:collaborator)                 { active_team_collaboratorship.user }
  let(:pending_team_membership)      { FactoryGirl.create(:pending_team_membership, joinable: team) }
  let(:pending_member)               { pending_team_membership.user }
  let(:active_clientship)            { FactoryGirl.create(:active_clientship, joinable_id: team.id, joinable_type: "Team") }
  let(:client)                       { active_clientship.user }
  let(:activity)                     { FactoryGirl.create(:activity, team: team) }

  it "is valid" do
    expect(team).to be_valid
  end

  it "is invalid without an owner" do
    team.owner = nil
    expect(team).to_not be_valid
  end

  it "is invalid without a name" do
    team.name = nil
    expect(team).to_not be_valid
  end

  describe "#projects" do
    it "returns the team's projects" do
      expect(team.projects).to include(project)
      expect(team.projects.length).to be(1)
    end
  end

  describe "#owner" do
    it "returns the team's owner" do
      expect(active_team_ownership).to be_valid
      expect(owner.teams).to include(team)
      expect(team.owner).to eql(owner)
    end
  end

  describe "#clients" do
    it "returns the team's clients" do
      expect(active_clientship).to be_valid
      expect(active_clientship.team).to eql(team)
      expect(team.clients).to include(client)
      expect(team.clients.length).to be(1)
    end
  end

  describe "#members" do
    it "returns the team's active members" do
      expect(active_team_collaboratorship).to be_valid
      expect(collaborator.teams).to include(team)
      expect(active_team_ownership).to be_valid
      expect(pending_team_membership).to be_valid
      expect(owner.teams).to include(team)
      expect(team.members).to include(collaborator)
      expect(team.members).to include(owner)
      expect(team.members).to_not include(pending_member)
      expect(team.members.length).to eql(2)
    end
  end

  describe "#pending_members" do
    it "returns the team's pending members" do
      expect(pending_team_membership).to be_valid
      expect(team.pending_members).to include(pending_member)
      expect(team.pending_members.length).to eql(1)
    end
  end

  describe "#activities" do
    it "returns the team's activities" do
      expect(activity).to be_valid
      expect(team.activities).to include(activity)
      expect(team.activities.length).to eql(1)
    end
  end
end
