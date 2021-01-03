FactoryBot.define do
  factory :note do
    title { 'てすとタイトル' }
    body { 'テストテキスト' }
    association :user
    association :category

    transient do
      tags { [create(:tag)] }
    end

    trait :set_tags do
      after(:create) do |note, evaluator|
        evaluator.tags.each do |tag|
          create(:note_tag, note: note, tag: tag)
        end
      end
    end
  end
end
