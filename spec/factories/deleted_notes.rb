FactoryBot.define do
  factory :deleted_note do
    guid { "xxxx" }
    association :user
  end
end
