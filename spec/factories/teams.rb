# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :team do
    name "MyString"
    description "MyString"
    owner_id 1
    website "MyString"
  end
end
