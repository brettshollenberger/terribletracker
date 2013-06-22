require 'spec_helper'

describe User do

  let(:user)       { FactoryGirl.create(:user) }
  let(:known_user) { FactoryGirl.create(:known_user) }

  it "is valid" do
    expect(user).to be_valid
    expect(known_user).to be_valid
  end

  it "is not valid without an email" do
    user.email = nil
    expect(user).to_not be_valid
  end

  it "is not valid without a first_name" do
    user.first_name = nil
    expect(user).to_not be_valid
  end

  it "is not valid without a last_name" do
    user.last_name = nil
    expect(user).to_not be_valid
  end
end
