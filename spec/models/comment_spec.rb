require 'spec_helper'

describe Comment do
  let(:comment) { FactoryGirl.create(:comment) }

  it "is valid" do
    expect(comment).to be_valid
  end

  it "is invalid without a user" do
    comment.user = nil
    expect(comment).to_not be_valid
  end

  it "is invalid without a commentable" do
    comment.commentable = nil
    expect(comment).to_not be_valid
  end
end
