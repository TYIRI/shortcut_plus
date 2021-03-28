class Comment < ApplicationRecord
  belongs_to :recipe
  belongs_to :user
  has_many :comment_likes, dependent: :destroy
  has_many :liked_users, through: :comment_likes, source: :user
  has_rich_text :content

  validates :content, presence: true
end
