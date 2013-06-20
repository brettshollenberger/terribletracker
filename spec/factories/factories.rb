# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :user do
    sequence(:email) { |n| "yoda@dagobah#{n}.com" }
    password "foobar29"
  end

end
