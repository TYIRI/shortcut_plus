FactoryBot.define do
  factory :comment do
    content { "コメントの内容です。" }
    association :recipe
    association :user
  end
end
