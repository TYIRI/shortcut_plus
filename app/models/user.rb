class User < ApplicationRecord
  authenticates_with_sorcery!
  has_many :recipes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :recipe_likes, dependent: :destroy
  has_many :liked_recipes, through: :recipe_likes, source: :recipe

  validates :name, presence: true, uniqueness: true, length: { maximum: 50 }
  validates :email, presence: true, uniqueness: true
  validates :role, presence: true
  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  enum role: { general: 0, admin: 1 }

  def to_param
    name
  end

  # レシピをLikeしていたらtrueを返す
  def liked_recipe?(recipe)
    liked_recipes.include?(recipe)
  end

  # レシピをLikeする
  def like_recipe(recipe)
    liked_recipes << recipe
  end

  # レシピのLikeを解除する
  def unlike_recipe(recipe)
    recipe_likes.find_by(recipe_id: recipe.id).destroy
  end
end
