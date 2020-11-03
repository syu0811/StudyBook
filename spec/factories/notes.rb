FactoryBot.define do
  factory :note do
    title { 'てすとタイトル' }
    text { 'テストテキスト' }
    user
    category
  end
end
