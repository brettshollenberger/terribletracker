require 'spec_helper'

describe User do

  let(:project)       { FactoryGirl.create(:project) }

  it "is valid" do
    expect(project).to be_valid
  end

  it "is not valid without a title" do
    project.title = nil
    expect(project).to_not be_valid
  end

  it "is not valid without a description" do
    project.description = nil
    expect(project).to_not be_valid
  end

  it "is not valid without a team" do
    project.team = nil
    expect(project).to_not be_valid
  end
end
