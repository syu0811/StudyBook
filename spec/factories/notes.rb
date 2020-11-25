FactoryBot.define do
  factory :note do
    title { 'てすとタイトル' }
    body { 'テストテキスト' }
    association :user
    association :category
  end
end
