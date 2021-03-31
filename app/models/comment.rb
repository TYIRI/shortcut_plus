class Comment < ApplicationRecord
  belongs_to :recipe
  belongs_to :user
  has_many :comment_likes, dependent: :destroy
  has_many :liked_users, through: :comment_likes, source: :user
  has_many :notifications, dependent: :destroy
  has_rich_text :content

  validates :content, presence: true

  def create_notification_like(current_user)
    temp = Notification.where("visitor_id = ? and visited_id = ? and comment_id = ? and action = ?", current_user.id, user_id, id, 'like')

    if temp.blank?
      notification = current_user.active_notifications.new(comment_id: id, visited_id: user_id, action: 'like')
      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
    end
  end
end
