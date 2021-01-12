FactoryBot.define do
  factory :user do
    firstname { 'てすと' }
    lastname { 'ゆーざー漢字' }
    sequence(:nickname) { |n| "Nick-kName_#{n}" }
    birthdate { 20.year.ago }
    sequence(:email) { |n| "email#{n}@example.com" }
    password { 'password' }
    password_confirmation { 'password' }
    confirmed_at { Time.zone.now }
    admin { false }
  end
end
