FactoryBot.define do
  factory :note do
    title { 'てすとタイトル' }
    text { 'テストテキスト' }
    association :user
  end
end
