class Recipe < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :tag_maps
  has_many :comments, dependent: :destroy
  has_many :recipe_likes, dependent: :destroy
  has_many :liked_users, through: :recipe_likes, source: :user
  has_many :tags, through: :tag_maps

  is_impressionable counter_cache: true

  with_options if: :published? do
    validates :title, presence: true
    validates :content, presence: true
    validates :category_id, presence: true
  end

  enum status: { draft: 0, published: 1 }

  scope :by_category, ->(category_id) { where(category_id: category_id) }
  scope :title_contain, ->(word) { where('title LIKE ?', "%#{word}%") }
  scope :content_contain, ->(word) { where('content LIKE ?', "%#{word}%") }

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
end
