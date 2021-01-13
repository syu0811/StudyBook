FactoryBot.define do
  factory :my_list do
    association :user
    association :category
    sequence(:title) { |n| "マイリストタイトル_#{n}" }
    description { 'これはマイリストの説明です' }
  end
end
