require 'spec_helper'

describe Project do

  let(:membership)    { FactoryGirl.create(:membership) }
  let(:project)       { membership.project }
  let(:user)          { membership.user }

  it "is valid" do
    expect(project).to be_valid
  end

  it "is not valid without a title" do
    project.title = nil
    expect(project).to_not be_valid
  end

  it "is not valid without a team" do
    project.team = nil
    expect(project).to_not be_valid
  end

  describe "#deactivate" do
    it "sets the project to inactive state" do
      project.deactivate
      expect(project.state).to eql("inactive")
    end
  end

  describe "#activate" do
    it "sets the project to active state" do
      project.deactivate
      project.activate
      expect(project.state).to eql("active")
    end
  end

  describe "#owner" do
    it "returns the project owner" do
      expect(project.owner).to eql(user)
    end

  end

  describe "active_users" do
    it "returns the users with an active project membership" do
      expect(project.active_users).to include(user)
      expect(project.active_users.length).to eql(1)
    end
  end
end
