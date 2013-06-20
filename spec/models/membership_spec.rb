require 'spec_helper'

describe Membership do
  let(:membership)           { FactoryGirl.create(:membership)}
  let(:active_owner)         { FactoryGirl.create(:active_owner) }
  let(:pending_owner)        { FactoryGirl.create(:pending_owner) }
  let(:closed_owner)         { FactoryGirl.create(:closed_owner) }
  let(:pending_collaborator) { FactoryGirl.create(:pending_collaborator) }
  let(:active_collaborator)  { FactoryGirl.create(:active_collaborator) }
  let(:closed_collaborator)  { FactoryGirl.create(:closed_collaborator) }
  let(:pending_client)       { FactoryGirl.create(:pending_client) }
  let(:active_client)        { FactoryGirl.create(:active_client) }
  let(:closed_client)        { FactoryGirl.create(:closed_client) }

  it "is valid" do
    expect(membership).to be_valid
    expect(active_owner).to be_valid
    expect(pending_owner).to be_valid
    expect(closed_owner).to be_valid
    expect(pending_collaborator).to be_valid
    expect(active_collaborator).to be_valid
    expect(closed_collaborator).to be_valid
    expect(pending_client).to be_valid
    expect(active_client).to be_valid
    expect(closed_client).to be_valid
  end

  it "is not valid with a non-standard role" do
    membership.role = "creator"
    expect(membership).to_not be_valid
    membership.role = "developer"
    expect(membership).to_not be_valid
  end

  it "is not valid with a non-standard state" do
    membership.state = "banned"
    expect(membership).to_not be_valid
    membership.state = "dead"
    expect(membership).to_not be_valid
  end

  it "validates" do
    expect(membership).to validate_presence_of("project")
    expect(membership).to validate_presence_of("user")
    expect(membership).to validate_presence_of("project_id")
    expect(membership).to validate_presence_of("user_id")
    expect(membership).to validate_presence_of("state")
  end
end
