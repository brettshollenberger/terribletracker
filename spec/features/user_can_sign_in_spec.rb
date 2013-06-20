require 'spec_helper'

include Warden::Test::Helpers
Warden.test_mode!

feature "user can sign in" do
  background do
    user = FactoryGirl.create(:user)
    login_as(user, :scope => :user)
    visit root_path
  end

  scenario "user sees empty project page" do
    expect(page).to have_content("New Project")
  end
end
