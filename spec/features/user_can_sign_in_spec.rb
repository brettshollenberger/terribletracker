require 'spec_helper'

include Warden::Test::Helpers
Warden.test_mode!

feature "user can sign in", js: true do
  background do
    user = FactoryGirl.create(:user)
    login(user)
  end

  scenario "user sees empty project page" do
    expect(page).to have_content("Get started by adding your team")
  end
end
