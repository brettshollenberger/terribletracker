require 'spec_helper'

describe UserStory do
  let(:user_story) { FactoryGirl.create(:user_story) }

  it "is valid" do
    expect(user_story).to be_valid
  end

  it "is invalid without a title" do
    user_story.title = nil
    expect(user_story).to_not be_valid
  end


  it "is invalid without a story" do
    user_story.story = nil
    expect(user_story).to_not be_valid
  end
end
