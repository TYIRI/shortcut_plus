class News < ApplicationRecord
  has_rich_text :content

  default_scope -> { order(created_at: :desc) }
end
