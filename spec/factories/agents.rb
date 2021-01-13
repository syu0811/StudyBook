FactoryBot.define do
  factory :agent do
    guid { "e0fc86fc-fb45-4351-8b2e-e8c2f3cb5fdd" }
    sequence(:token) { |n| "xxxxxxxxx#{n}" }
    association :user
  end
end
