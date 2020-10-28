FactoryBot.define do
  factory :my_list do
    user
    category
    title { 'マイリストタイトル' }
    description { 'これはマイリストの説明です' }
  end
end
