require 'spec_helper'

feature "user can sign in" do
  background do
    user = FactoryGirl.create(:user)
    sign_in(:user, scope: :user)
  end

  scenario "user sees empty project page" do
    expect(page).to have_content("New Project")
  end
end
