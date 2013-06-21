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

    factory :active_ownership, traits: [:active, :owner]
    factory :pending_ownership, traits: [:pending, :owner]
    factory :closed_ownership, traits: [:closed, :owner]
    factory :pending_collaboratorship, traits: [:pending, :collaborator]
    factory :active_collaboratorship, traits: [:active, :collaborator]
    factory :closed_collaboratorship, traits: [:closed, :collaborator]
    factory :pending_clientship, traits: [:pending, :client]
    factory :active_clientship, traits: [:active, :client]
    factory :closed_clientship, traits: [:closed, :client]
  end

  factory :user_story do
    title "Terrible Story"
    story "As a user, I want to take over the world, so I can be its sole leader."
    estimate_in_quarter_days 1
    complexity 1
    project
  end

end
