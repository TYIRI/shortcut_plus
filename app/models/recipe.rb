class Recipe < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :recipe_tags
  has_many :comments

  with_options if: :published? do
    validates :title, presence: true
    validates :content, presence: true
    validates :category_id, presence: true
    validates :published_at, presence: true
  end

  enum status: { draft: 0, published: 1 }

  scope :by_category, ->(category_id) { where(category_id: category_id) }
  scope :title_contain, ->(word) { where('title LIKE ?', "%#{word}%") }
  scope :content_contain, ->(word) { where('content LIKE ?', "%#{word}%") }
end