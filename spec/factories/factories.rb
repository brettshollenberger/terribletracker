# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :user do
    sequence(:email) { |n| "yoda@dagobah#{n}.com" }
    password "foobar29"
    sequence(:first_name) { |n| "Yoda#{n}" }
    last_name "The Great One"
  end

  factory :project do
    sequence(:title) { |n| "My Awesome Project #{n}" }
    description "My project is incredible!"
    budget 1000000000
    weekly_rate 10
    team
  end

  factory :membership do
    user
    role "owner"
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

    trait :joinable_project do
      association :joinable, factory: :project
    end

    trait :joinable_team do
      association :joinable, factory: :team
    end

    factory :active_ownership, traits: [:active, :owner, :joinable_project]
    factory :pending_ownership, traits: [:pending, :owner, :joinable_project]
    factory :pending_collaboratorship, traits: [:pending, :collaborator, :joinable_project]
    factory :active_collaboratorship, traits: [:active, :collaborator, :joinable_project]
    factory :pending_clientship, traits: [:pending, :client, :joinable_team]
    factory :active_clientship, traits: [:active, :client, :joinable_team]
    factory :active_team_ownership, traits: [:active, :owner, :joinable_team]
    factory :active_team_collaboratorship, traits: [:active, :collaborator, :joinable_team]
    factory :pending_team_membership, traits: [:pending, :collaborator, :joinable_team]
    factory :active_team_membership, traits: [:active, :collaborator, :joinable_team]
  end

  factory :user_story do
    sequence(:title) { |n| "Awesome Story #{n}"}
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
    sequence(:name) { |n| "The Merry Men #{n}" }
    description "A very funny group of men"
    association :owner, factory: :user
    website "themerrymen.com"
  end

  factory :comment do
    body "Cool dog!"
    user
    association :commentable, factory: :user_story
  end

  factory :activity do
    user
    team
    action "create"
    association :trackable, factory: :user_story
  end

end
