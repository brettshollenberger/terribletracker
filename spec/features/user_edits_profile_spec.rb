require 'spec_helper'

include Warden::Test::Helpers
Warden.test_mode!

feature "user can edit their profile" do
  background do
    @user = FactoryGirl.create(:user)
    login_as(@user, :scope => :user)
    visit edit_user_registration_path(@user)
  end

  scenario "user edits their profile" do
    fill_in "First Name", with: "Darth"
    fill_in "Last Name", with: "Vader"
    fill_in "Current Password", with: @user.password
    click_button "Update Profile"
    @user.reload.first_name
    @user.reload.last_name

    expect(@user.first_name).to eql("Darth")
    expect(@user.last_name).to eql("Vader")
  end

end
