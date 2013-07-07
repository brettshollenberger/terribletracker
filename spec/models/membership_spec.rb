require 'spec_helper'

describe Membership do
  let(:membership)               { FactoryGirl.create(:membership) }
  let(:project)                  { membership.project }
  let(:active_ownership)         { FactoryGirl.create(:active_ownership) }
  let(:pending_ownership)        { FactoryGirl.create(:pending_ownership) }
  let(:pending_collaboratorship) { FactoryGirl.create(:pending_collaboratorship) }
  let(:active_collaboratorship)  { FactoryGirl.create(:active_collaboratorship) }
  let(:pending_clientship)       { FactoryGirl.create(:pending_clientship) }
  let(:active_clientship)        { FactoryGirl.create(:active_clientship) }
  let(:active_team_ownership)    { FactoryGirl.create(:active_team_ownership) }
  let(:team)                     { active_team_ownership.team }

  it "is valid" do
    expect(membership).to be_valid
    expect(active_ownership).to be_valid
    expect(pending_ownership).to be_valid
    expect(pending_collaboratorship).to be_valid
    expect(active_collaboratorship).to be_valid
    expect(pending_clientship).to be_valid
    expect(active_clientship).to be_valid
    expect(active_team_ownership).to be_valid
  end

  it "is not valid with a non-standard role" do
    membership.role = "creator"
    expect(membership).to_not be_valid
    membership.role = "developer"
    expect(membership).to_not be_valid
  end

  it "is not valid with a non-standard state" do
    membership.state = "banned"
    expect(membership).to_not be_valid
    membership.state = "dead"
    expect(membership).to_not be_valid
  end

  it "validates" do
    expect(membership).to validate_presence_of("joinable_id")
    expect(membership).to validate_presence_of("joinable_type")
    expect(membership).to validate_presence_of("joinable")
    expect(membership).to validate_presence_of("user")
    expect(membership).to validate_presence_of("user_id")
    expect(membership).to validate_presence_of("state")
  end

  describe "#deactivate" do
    it "deactivates the membership" do
      membership.deactivate
      expect(membership.state).to eql('inactive')
    end
  end

  describe "#activate" do
    it "activates the membership" do
      membership.deactivate
      membership.activate
      expect(membership.state).to eql('active')
    end
  end

  describe "#project" do
    let(:membership)               { FactoryGirl.create(:membership) }
    let(:project)                  { membership.project }

    it "returns the project" do
      expect(membership.project).to eql(project)
    end
  end

  describe "#team" do
    let(:active_team_ownership)    { FactoryGirl.create(:active_team_ownership) }
    let(:team)                     { active_team_ownership.team }

    it "returns the team" do
      expect(active_team_ownership.team).to eql(team)
    end
  end

end
