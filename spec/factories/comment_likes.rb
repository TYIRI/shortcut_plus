FactoryBot.define do
  factory :comment_like do
    association :comment
    association :user
  end
end
