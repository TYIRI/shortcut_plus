FactoryBot.define do
  factory :tag_map do
    association :recipe
    association :tag
  end
end
