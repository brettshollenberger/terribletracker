# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_story do
    title "MyString"
    story "MyText"
    estimate_in_quarter_days 1
    complexity 1
    project_id 1
  end
end
