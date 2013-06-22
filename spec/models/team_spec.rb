require 'spec_helper'

describe Team do
  let(:team) { FactoryGirl.create(:team) }

  it "is valid" do
    expect(team).to be_valid
  end

  it "is invalid without an owner" do
    team.owner_id = nil
    expect(team).to_not be_valid
  end

  it "is invalid without a name" do
    team.name = nil
    expect(team).to_not be_valid
  end
end
