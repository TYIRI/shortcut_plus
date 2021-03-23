class Comment < ApplicationRecord
  belongs_to :recipe
  belongs_to :user
  has_many :comment_likes, dependent: :destroy
  has_many :liked_users, through: :comment_likes, source: :user

  validates :content, presence: true
end
