class Recipe < ApplicationRecord
  belongs_to :user
  belongs_to :category, optional: true
  has_many :tag_maps
  has_many :comments, dependent: :destroy
  has_many :recipe_likes, dependent: :destroy
  has_many :liked_users, through: :recipe_likes, source: :user
  has_many :tags, through: :tag_maps
  has_many :notifications, dependent: :destroy
  has_rich_text :content

  validates :title, length: { maximum: 100 }
  
  with_options if: :published? do
    validates :title, presence: true
    validates :content, presence: true
    validates :category_id, presence: { message: "を選択してください"}
  end

  is_impressionable counter_cache: true

  enum status: { draft: 0, published: 1 }

  scope :by_category, ->(category_id) { where(category_id: category_id) }
  scope :title_and_content_contain, -> (search_param = nil) {
    return if search_param.blank?
    joins("INNER JOIN action_text_rich_texts ON action_text_rich_texts.record_id = recipes.id AND action_text_rich_texts.record_type = 'Recipe'")
    .where("action_text_rich_texts.body LIKE ? OR recipes.title LIKE ? ", "%#{search_param}%", "%#{search_param}%")
  }

  def save_recipe_with_tags(save_tags)
    current_tags = self.tags.pluck(:name) unless self.tags.nil?
    old_tags = current_tags - save_tags
    new_tags = save_tags - current_tags

    old_tags.each do |name|
      self.tags.delete Tag.find_by(name: name)
    end

    new_tags.each do |name|
      recipe_tag = Tag.find_or_create_by(name: name)
      self.tags << recipe_tag
    end
  end

  def create_notification_like(current_user)
    temp = Notification.where("visitor_id = ? and visited_id = ? and recipe_id = ? and action = ?", current_user.id, user_id, id, 'recipe_like')

    if temp.blank?
      notification = current_user.active_notifications.new(recipe_id: id, visited_id: user_id, action: 'recipe_like')
      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
    end
  end

  def create_notification_comment(current_user, comment_id)
    temp_ids = Comment.select(:user_id).where(recipe_id: id).where.not(user_id: current_user.id).distinct
    temp_ids.each do |temp_id|
      save_notification_comment(current_user, comment_id, temp_id['user_id'])
    end
    save_notification_comment(current_user, comment_id, user_id) if temp_ids.blank?
  end

  def save_notification_comment(current_user, comment_id, visited_id)
    if user.id == visited_id
      action = 'recipe_comment'
    else
      action = 'others_recipe_comment'
    end

    notification = current_user.active_notifications.new(recipe_id: id, comment_id: comment_id, visited_id: visited_id, action: action)
    if notification.visitor_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
  end
end
