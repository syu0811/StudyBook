FactoryBot.define do
  factory :note_readed_user do
    association :note
    association :user
  end
end
