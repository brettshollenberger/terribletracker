# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :user do
    sequence(:email) { |n| "yoda@dagobah#{n}.com" }
    password "foobar29"
    first_name "Yoda"
    last_name "The Great One"
  end

  factory :project do
    sequence(:title) { |n| "My Awesome Project #{n}" }
    description "My project is incredible!"
    budget 1
    weekly_rate 1
    user
  end

end
