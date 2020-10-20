FactoryBot.define do
  factory :tag do
    sequence(:name) { |n| "TagName_#{n}" }
  end
end
