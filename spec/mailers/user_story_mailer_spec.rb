require "spec_helper"

include EmailSpec::Helpers
include EmailSpec::Matchers

describe UserStoryMailer do

  before(:each) do

    create_team_with_project
    login(@owner)
    visit_project_path(@project)

    find('.assign-button').click
    page.should have_content(@collaborator.full_name)
    click_on @collaborator.full_name

    # Doesn't test anything, but it's necessary to make Capybara
    # wait to find the generated project activity on the page before
    # attempting to create the assignment mailer.
    find('#project-activities-table').should have_content("assigned")

    @email = UserStoryMailer.assignment_mailer(
        @collaborator,
        @story)
  end

  context "assignment_mailer", type: :feature, js: true do

    it "is delivered to the assigned user" do
      @email.should deliver_to(@collaborator.email)
    end

    it "should contain the user's name in the message" do
      @email.should have_body_text(@collaborator.first_name)
    end

    it "should have the correct subject" do
      @email.should have_subject("You've been assigned to #{@story.title} on Terrible Tracker")
    end

  end

end
