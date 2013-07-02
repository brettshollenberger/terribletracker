require 'spec_helper'

describe UserStoryDecorator do

  before :each do
    @active_team_membership = FactoryGirl.create(:active_team_membership)
    @user = @active_team_membership.user
    @team = @active_team_membership.joinable
    @project = FactoryGirl.create(:project, team: @team)
    @project_membership = FactoryGirl.create(:active_collaboratorship, joinable: @project)
    @user_story = FactoryGirl.create(:user_story, project: @project).decorate
  end

  describe "estimated method" do

    it "returns estimated time in quarter days" do
      @user_story.estimate_in_quarter_days = 4
      expect(@user_story.estimated).to eql("1 day")
    end

    it "returns estimated time in quarter days" do
      @user_story.estimate_in_quarter_days = 6
      expect(@user_story.estimated).to eql("1.5 days")
    end

    it "returns estimated time in quarter days" do
      @user_story.estimate_in_quarter_days = 5
      expect(@user_story.estimated).to eql("1.25 days")
    end

  end

  describe "state_button method" do

    it "outputs formatted HTML" do
      expect(@user_story.state_button).to include("<div class=\"btn-group\"><a href=\"#\" class=\"btn dropdown-toggle state-btn\" data-toggle=\"dropdown\">")
    end

    it "formats based on user story state" do
      @user_story.state = "started"
      expect(@user_story.state_button).to include("btn-primary")
    end

    it "code review example" do
      @user_story.state = "review"
      expect(@user_story.state_button).to include("btn-warning")
    end

    it "finished example" do
      @user_story.state = "finished"
      expect(@user_story.state_button).to include("btn-success")
    end
  end

  describe "assign_button method" do

    it "outputs formatted HTML" do
      expect(@user_story.assign_button).to include('<a href="/user_story/1/assign/3" data-remote="true">Yoda')
    end

  end
end
