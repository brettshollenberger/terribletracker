# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :user do
    sequence(:email) { |n| "yoda@dagobah#{n}.com" }
    password "foobar29"
    first_name "Yoda"
    last_name "The Great One"

    trait :one do
      id 1
    end
  end

  factory :project do
    sequence(:title) { |n| "My Awesome Project #{n}" }
    description "My project is incredible!"
    budget 1
    weekly_rate 1
  end

  factory :membership do
    user
    role "collaborator"
    state "active"
    inviter_id 1
    association :joinable, factory: :project

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

    trait :joinable_project do
      association :joinable, factory: :project
    end

    trait :joinable_team do
      association :joinable, factory: :team
    end

    factory :active_ownership, traits: [:active, :owner, :joinable_project]
    factory :pending_ownership, traits: [:pending, :owner, :joinable_project]
    factory :closed_ownership, traits: [:closed, :owner, :joinable_project]
    factory :pending_collaboratorship, traits: [:pending, :collaborator, :joinable_project]
    factory :active_collaboratorship, traits: [:active, :collaborator, :joinable_project]
    factory :closed_collaboratorship, traits: [:closed, :collaborator, :joinable_project]
    factory :pending_clientship, traits: [:pending, :client, :joinable_project]
    factory :active_clientship, traits: [:active, :client, :joinable_project]
    factory :closed_clientship, traits: [:closed, :client, :joinable_project]
  end

  factory :user_story do
    title "Terrible Story"
    story "As a user, I want to take over the world, so I can be its sole leader."
    estimate_in_quarter_days 1
    complexity 1
    state "unstarted"
    project

    trait :started do
      state "started"
    end

    trait :review do
      state "review"
    end

    trait :finished do
      state "finished"
    end

    factory :started_story, traits: [:started]
    factory :review_story, traits: [:review]
    factory :finished_story, traits: [:finished]
  end

  factory :team do
    name "The Merry Men"
    description "A very funny group of men"
    owner_id 1
    website "themerrymen.com"
  end

end
