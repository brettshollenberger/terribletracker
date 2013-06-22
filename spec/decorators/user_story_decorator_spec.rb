require 'spec_helper'

describe UserStoryDecorator do

  describe "estimated method" do

    before(:each) do
      @story = FactoryGirl.create(:user_story).decorate
    end

    it "returns estimated time in quarter days" do
      @story.estimate_in_quarter_days = 4
      expect(@story.estimated).to eql("1 day")
    end

    it "returns estimated time in quarter days" do
      @story.estimate_in_quarter_days = 6
      expect(@story.estimated).to eql("1.5 days")
    end

    it "returns estimated time in quarter days" do
      @story.estimate_in_quarter_days = 5
      expect(@story.estimated).to eql("1.25 days")
    end

  end

  describe "state_button method" do
    let(:user_story) { FactoryGirl.create(:user_story).decorate }

    it "outputs formatted HTML" do
      expect(user_story.state_button).to include("<div class=\"btn-group\"><a href=\"#\" class=\"btn dropdown-toggle state-btn\" data-toggle=\"dropdown\">")
    end

    it "formats based on user story state" do
      user_story.state = "started"
      expect(user_story.state_button).to include("btn-primary")
    end

    it "code review example" do
      user_story.state = "review"
      expect(user_story.state_button).to include("btn-warning")
    end

    it "finished example" do
      user_story.state = "finished"
      expect(user_story.state_button).to include("btn-success")
    end
  end
end
