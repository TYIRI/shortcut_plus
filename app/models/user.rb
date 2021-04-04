class User < ApplicationRecord
  attr_accessor :email_change_token
  authenticates_with_sorcery!

  has_many :recipes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :recipe_likes, dependent: :destroy
  has_many :liked_recipes, through: :recipe_likes, source: :recipe
  has_many :comment_likes, dependent: :destroy
  has_many :liked_comments, through: :comment_likes, source: :comment
  has_many :active_notifications, class_name: 'Notification', foreign_key: 'visitor_id', dependent: :destroy
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy
  has_one_attached :avatar

  VALID_NAME_REGEX = /\A[a-zA-Z0-9]+[a-zA-Z0-9_-]*[a-zA-Z0-9]+\z/i
  INVALID_NAME_REGEX = /\A(user[s]*|recipe[s]*|categories|tags|comment[s]*|preview[s]*|recipe_like[s]*|comment_like[s]*|password_reset[s]*|notification[s]*|setting[s]*|email_change[s]*|my_recipe[s]*|search[s]*|login[s]*|logout[s]*|labo[s]*)\z/i
  VALID_EMAIL_REGEX = /\A[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*\z/i

  validates :name, presence: true, uniqueness: true, length: { in: 3..50 }, format: { with: VALID_NAME_REGEX }, format: { without: INVALID_NAME_REGEX }
  validates :email, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX }
  validates :role, presence: true
  validates :notification_recipe_like, inclusion: { in: [true, false] }
  validates :notification_comment_like, inclusion: { in: [true, false] }
  validates :notification_recipe_comment, inclusion: { in: [true, false] }
  validates :notification_others_recipe_comment, inclusion: { in: [true, false] }
  validates :password, length: { minimum: 8 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :avatar, attachment: { purge: true, content_type: %r{\Aimage/(png|jpeg)\Z}, maximum: 10_485_760 }

  enum role: { general: 0, admin: 1 }

  def to_param
    name
  end

  def own?(object)
    object.user_id == id
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
  def dislike_recipe(recipe)
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
  def dislike_comment(comment)
    comment_likes.find_by(comment_id: comment.id).destroy
  end
end
