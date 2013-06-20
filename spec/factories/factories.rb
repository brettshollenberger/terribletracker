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
  end

  factory :membership do
    user
    project
    role "collaborator"
    state "active"

    trait :owner do
      role "owner"
    end

    trait :collaborator do
      role "collaborator"
    end

    trait :client do
      role "client"
    end

    trait :pending do
      state "pending"
    end

    trait :active do
      state "active"
    end

    trait :closed do
      state "closed"
    end

    factory :active_owner, traits: [:active, :owner]
    factory :pending_owner, traits: [:pending, :owner]
    factory :closed_owner, traits: [:closed, :owner]
    factory :pending_collaborator, traits: [:pending, :collaborator]
    factory :active_collaborator, traits: [:active, :collaborator]
    factory :closed_collaborator, traits: [:closed, :collaborator]
    factory :pending_client, traits: [:pending, :client]
    factory :active_client, traits: [:active, :client]
    factory :closed_client, traits: [:closed, :client]
  end

end
