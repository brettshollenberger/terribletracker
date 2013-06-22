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
    login_as(@user, :scope => :user)
    visit edit_user_registration_path
  end

  scenario "user adds a client" do

  end

end
