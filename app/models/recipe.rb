class Recipe < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :recipe_tags

  enum status: { draft: 0, published: 1 }
end
