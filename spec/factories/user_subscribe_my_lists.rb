FactoryBot.define do
  factory :user_subscribe_my_list do
    association :user
    association :my_list
  end
end
