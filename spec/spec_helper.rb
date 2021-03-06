# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'capybara/rspec'
require 'capybara/rails'
require "email_spec"
require 'capybara/poltergeist'
require 'database_cleaner'

Capybara.javascript_driver = :poltergeist

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, :js_errors => false)
end

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"
  config.include(EmailSpec::Helpers)
  config.include(EmailSpec::Matchers)
end

def login(user)
  visit root_path
  fill_in "Email", with: user.email
  fill_in "Password", with: "foobar29"
  click_on "Sign in"
end

def visit_team_path(team)
  find("#team_name_#{team.id}").click
end

def visit_project_path(project)
  visit_team_path(project.team)
  find("#project_title_#{project.id}").click
end

def press_enter(form)
  # Simulate form submission
  keypress_script = "$('#{form}').submit();"
  page.driver.execute_script(keypress_script)
end

def logout
  find('#logout-btn').click
end

def create_team_with_project
  @ownership = FactoryGirl.create(:active_team_ownership)
  @owner = @ownership.user.decorate
  @team = @ownership.team
  @project = FactoryGirl.create(:project, team: @team)
  @story = FactoryGirl.create(:user_story, project: @project)
  @comment = FactoryGirl.create(:comment, commentable: @story)
  @collaboratorship = FactoryGirl.create(:active_team_membership, joinable: @team)
  @collaborator = @collaboratorship.user.decorate
  @users = [@owner, @collaborator]
  @users.each { |user| FactoryGirl.create(:membership, joinable: @project, user: user) }
  @activity = FactoryGirl.create(:activity, trackable: @story, team: @team, user: @owner)
  @team_name = @team.name
  @project_title = @project.title
end
