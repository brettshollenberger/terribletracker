require 'spec_helper'

describe "Activity Tracker" do
  let(:user_story) { FactoryGirl.create(:user_story) }

  before :each do
    create_team_with_project
  end

  it "is just a template; it does not create valid activities objects" do
    @tracker = ActivityTracker::TerribleActivityTracker.new(user_story)
    expect(@tracker.save).to_not be_valid
  end

end
