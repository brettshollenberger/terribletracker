require 'spec_helper'

describe User do

  let(:user)       { FactoryGirl.create(:user) }

  it "is valid" do
    expect(user).to be_valid
  end

  it "is not valid without an email" do
    user.email = nil
    expect(user).to_not be_valid
  end

  it "is not valid without a first_name" do
    user.first_name = nil
    expect(user).to_not be_valid
  end

  it "is not valid without a last_name" do
    user.last_name = nil
    expect(user).to_not be_valid
  end

  describe "#recent_activities" do
    let(:ownership) { FactoryGirl.create(:active_team_ownership) }

    before :each do
      @owner = ownership.user
      @team = ownership.team
      @project = FactoryGirl.create(:project, team: @team)
      @membership = FactoryGirl.create(:membership, joinable: @project, user: @owner)
    end

    it 'returns the activities from a single team' do
      activity = FactoryGirl.create(:activity, team: @team)

      @project.team.owner.recent_activities.should include(activity)
    end

    it 'excludes the activities from unrelated teams' do
      relevant_activity = FactoryGirl.create(:activity, team: @team)
      other_activity = FactoryGirl.create(:activity)

      activities = @project.team.owner.recent_activities
      activities.should include(relevant_activity)
      activities.should_not include(other_activity)
    end

    it 'mixes multiple teams' do
      user = @project.team.owner
      first_team = @project.team

      second_team = FactoryGirl.create(:team, owner: user)
      second_project = FactoryGirl.create(:project, team: second_team)
      FactoryGirl.create(:active_team_ownership, joinable: second_team, user: user)

      first_activity = FactoryGirl.create(:activity, team: first_team, created_at: 1.hour.ago)
      second_activity = FactoryGirl.create(:activity, team: second_team, created_at: 2.hours.ago)
      third_activity = FactoryGirl.create(:activity, team: first_team, created_at: 3.hours.ago)

      user.recent_activities.should == [first_activity, second_activity, third_activity]
    end
  end
end
