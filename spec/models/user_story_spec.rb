require 'spec_helper'

describe UserStory do
  let(:user_story)     { FactoryGirl.create(:user_story) }
  let(:started_story)  { FactoryGirl.create(:started_story) }
  let(:review_story)   { FactoryGirl.create(:review_story) }
  let(:finished_story) { FactoryGirl.create(:finished_story) }

  it "is valid" do
    expect(user_story).to be_valid
    expect(started_story).to be_valid
    expect(review_story).to be_valid
    expect(finished_story).to be_valid
  end

  it "is invalid without a title" do
    user_story.title = nil
    expect(user_story).to_not be_valid
  end

  it "is invalid without a state" do
    user_story.state = nil
    expect(user_story).to_not be_valid
  end
end
