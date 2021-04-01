class Notification < ApplicationRecord
  belongs_to :recipe, optional: true
  belongs_to :comment, optional: true
  belongs_to :visitor, class_name: 'User', foreign_key: 'visitor_id', optional: true
  belongs_to :visited, class_name: 'User', foreign_key: 'visited_id', optional: true

  default_scope -> { order(created_at: :desc) }
  scope :recipe_like_off, -> { where.not("action = ?", 'recipe_like') }
  scope :comment_like_off, -> { where.not("action = ?", 'comment_like') }
  scope :recipe_comment_off, -> { where.not("action = ?", 'recipe_comment') }
  scope :others_recipe_comment_off, -> { where.not("action = ?", 'others_recipe_comment') }
end
