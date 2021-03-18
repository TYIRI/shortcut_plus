FactoryBot.define do
  factory :recipe do
    sequence(:title) { |n| "レシピタイトル#{n}" }
    content { "レシピの内容です。" }
    sequence(:shortcut_id) { |n| "shortcut#{n}" }
    
    trait :draft do
      status { "draft" }
    end
    
    trait :published do
      status { "published" }
      published_at { Time.current }
    end
  end
end
