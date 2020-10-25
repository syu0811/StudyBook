FactoryBot.define do
  factory :category do
    sequence(:name) { |n| "CategoryName_#{n}" }
  end
end
