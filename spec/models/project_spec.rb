require 'spec_helper'

describe User do

  let(:project)       { FactoryGirl.create(:project) }
  let(:known_project) { FactoryGirl.create(:known_project)}

  it "is valid" do
    expect(project).to be_valid
    expect(known_project).to be_valid
  end

  it "is not valid without a title" do
    project.title = nil
    expect(project).to_not be_valid
  end

  it "is not valid without a description" do
    project.description = nil
    expect(project).to_not be_valid
  end
end
