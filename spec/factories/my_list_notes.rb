FactoryBot.define do
  factory :my_list_note do
    association :my_list
    association :note
  end
end
