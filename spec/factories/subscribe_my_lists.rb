FactoryBot.define do
  factory :subscribe_my_list do
    association :user
    association :my_list
  end
end
