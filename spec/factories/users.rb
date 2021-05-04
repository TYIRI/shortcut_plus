FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "user-#{n}" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password1" }
    password_confirmation { "password1" }
    agreement { true }
  end
end
