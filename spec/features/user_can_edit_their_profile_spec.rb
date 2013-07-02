require 'spec_helper'

include Warden::Test::Helpers
Warden.test_mode!

feature 'users can edit their profiles', %q{
  As a user,
  I want to edit my profile,
  so I can keep my personal information up-to-date.
} do

  background do
    @user = FactoryGirl.create(:user)
    login(@user)
  end

  scenario "user edits their profile" do
    click_on "Edit Profile"
    fill_in "user[first_name]", with: "Clive"
    fill_in "user[current_password]", with: "foobar29"
    click_on "Update Profile"
    expect(@user.first_name).to eql("Clive")
  end

end
