class Recipe < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :recipe_tags
  has_many :comments

  enum status: { draft: 0, published: 1 }
end
