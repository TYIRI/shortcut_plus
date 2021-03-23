class User < ApplicationRecord
  authenticates_with_sorcery!
  has_many :recipes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :recipe_likes, dependent: :destroy
  has_many :liked_recipes, through: :recipe_likes, source: :recipe
  has_many :comment_likes, dependent: :destroy
  has_many :liked_comments, through: :comment_likes, source: :comment
  has_one_attached :avatar

  validates :name, presence: true, uniqueness: true, length: { maximum: 50 }
  validates :email, presence: true, uniqueness: true
  validates :role, presence: true
  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :avatar, attachment: { purge: true, content_type: %r{\Aimage/(png|jpeg)\Z}, maximum: 10_485_760 }

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

    # コメントをLikeしていたらtrueを返す
    def liked_comment?(comment)
      liked_comments.include?(comment)
    end
  
    # コメントをLikeする
    def like_comment(comment)
      liked_comments << comment
    end
  
    # コメントのLikeを解除する
    def unlike_comment(comment)
      comment_likes.find_by(comment_id: comment.id).destroy
    end
end
