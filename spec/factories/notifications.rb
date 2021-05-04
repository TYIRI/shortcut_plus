FactoryBot.define do
  factory :notification do
    visitor_id { 1 }
    visited_id { 1 }

    trait :recipe_like_checked do
      action { "recipe_like" }
      checked { true }
    end

    trait :recipe_like_unchecked do
      action { "recipe_like" }
      checked { false }
    end

    trait :comment_like_checked do
      action { "comment_like" }
      checked { true }
    end

    trait :comment_like_unchecked do
      action { "comment_like" }
      checked { false }
    end

    trait :recipe_comment_checked do
      action { "recipe_comment" }
      checked { true }
    end

    trait :recipe_comment_unchecked do
      action { "recipe_comment" }
      checked { false }
    end

    trait :others_recipe_comment_checked do
      action { "others_recipe_comment" }
      checked { true }
    end

    trait :others_recipe_comment_unchecked do
      action { "others_recipe_comment" }
      checked { false }
    end
  end
end
