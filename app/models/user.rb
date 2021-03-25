class User < ApplicationRecord
  attr_accessor :email_change_token
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

  # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返す
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # メールアドレス変更用のトークンを生成する
  def generate_email_change_token
    self.email_change_token = User.new_token
    update_attribute(:email_change_digest, User.digest(email_change_token))
    update_attribute(:email_change_token_expires_at, Time.zone.now + 1.day)
    update_attribute(:email_change_email_sent_at, Time.zone.now)
  end

  # メールアドレス変更確認メールを送信する
  def send_email_change_email(new_email)
    update_attribute(:unconfirmed_email, new_email)
    UserMailer.email_change_email(self, new_email).deliver_now
  end

  # email_changeトークンがダイジェストと一致していたらtrueを返す
  def authenticated_email_change_token?(email_change_token)
    return false if email_change_digest.nil?
    BCrypt::Password.new(email_change_digest).is_password?(email_change_token)
  end

  # email_changeトークンの有効期間内ならtrueを返す
  def email_change_not_expired?
    return false if email_change_token_expires_at.nil?
    email_change_token_expires_at > Time.zone.now
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
