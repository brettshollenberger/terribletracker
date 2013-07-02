require 'spec_helper'

describe CommentDecorator do
  before :each do
    @comment = FactoryGirl.create(:comment).decorate
  end

  describe "pretty_created_at" do

    it "outputs just now when the comment is created" do
      expect(@comment.pretty_created_at).to eql("just now")
    end

    it "outputs a second ago a second after the comment is created" do
      @comment.created_at = Time.now - 1.second
      expect(@comment.pretty_created_at).to eql("a second ago")
    end

    it "outputs the number of seconds when it's been less than a minute since creation" do
      @comment.created_at = Time.now - 2.seconds
      expect(@comment.pretty_created_at).to eql("2 seconds ago")
      @comment.created_at = Time.now - 59.seconds
      expect(@comment.pretty_created_at).to eql("59 seconds ago")
    end

    it "outputs a minute when it's been less than two minutes since creation" do
      @comment.created_at = Time.now - 1.minute
      expect(@comment.pretty_created_at).to eql("a minute ago")
      @comment.created_at = Time.now - 119.seconds
      expect(@comment.pretty_created_at).to eql("a minute ago")
    end

    it "outputs the number of minutes when it's been less than an hour since creation" do
      @comment.created_at = Time.now - 2.minutes
      expect(@comment.pretty_created_at).to eql("2 minutes ago")
      @comment.created_at = Time.now - 3540.seconds
      expect(@comment.pretty_created_at).to eql("59 minutes ago")
    end

    it "outputs an hour ago when it's been less than two hours since creation" do
      @comment.created_at = Time.now - 1.hour
      expect(@comment.pretty_created_at).to eql("an hour ago")
      @comment.created_at = Time.now - 7100.seconds
      expect(@comment.pretty_created_at).to eql("an hour ago")
    end

    it "outputs Today at Time when it's been less than 24 hours" do
      @comment.created_at = Time.now - 2.hours
      expect(@comment.pretty_created_at).to eql("Today at#{@comment.created_at.strftime("%l:%M%p")}")
      @comment.created_at = Time.now - 82800.seconds
      expect(@comment.pretty_created_at).to eql("Today at#{@comment.created_at.strftime("%l:%M%p")}")
    end

    it "outputs Yesterday at Time when it's been less than 48 hours" do
      @comment.created_at = Time.now - 1.day
      expect(@comment.pretty_created_at).to eql("Yesterday at#{@comment.created_at.strftime("%l:%M%p")}")
      @comment.created_at = Time.now - 165600.seconds
      expect(@comment.pretty_created_at).to eql("Yesterday at#{@comment.created_at.strftime("%l:%M%p")}")
    end

  end

end
