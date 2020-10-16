FactoryBot.define do
  factory :note do
    title { 'てすとタイトル' }
    text { 'テストテキスト' }
    user
  end
end
