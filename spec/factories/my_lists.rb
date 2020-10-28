FactoryBot.define do
  factory :my_list do
    association :user
    association :category
    title { 'マイリストタイトル' }
    description { 'これはマイリストの説明です' }
  end
end
