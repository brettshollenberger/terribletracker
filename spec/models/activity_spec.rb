require 'spec_helper'

describe Activity do
  let(:activity) { FactoryGirl.create(:activity) }
  let(:user_story) { FactoryGirl.create(:user_story) }
  let(:project) { FactoryGirl.create(:project) }
  let(:comment) { FactoryGirl.create(:comment) }
  let(:membership) { FactoryGirl.create(:membership) }
  let(:team) { FactoryGirl.create(:team) }
  let(:user) { FactoryGirl.create(:user) }

  it "is valid" do
    expect(activity).to be_valid
  end

  it "isn't valid without a user" do
    activity.user = nil
    expect(activity).to_not be_valid
  end

  it "isn't valid without a team" do
    activity.team = nil
    expect(activity).to_not be_valid
  end

  it "accepts user story activity" do
    activity.trackable = user_story
    expect(activity).to be_valid
  end

  it "accepts project activity" do
    activity.trackable = project
    expect(activity).to be_valid
  end

  it "accepts comment activity" do
    activity.trackable = comment
    expect(activity).to be_valid
  end

  it "accepts membership activity" do
    activity.trackable = membership
    expect(activity).to be_valid
  end

  it "accepts team activity" do
    activity.trackable = team
    expect(activity).to be_valid
  end

  it "does not accept user activity" do
    activity.trackable = user
    expect(activity).to_not be_valid
  end

  it "does not accept activity activity" do
    activity.trackable = activity
    expect(activity).to_not be_valid
  end
end
