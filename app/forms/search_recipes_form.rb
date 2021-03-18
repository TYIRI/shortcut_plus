class SearchRecipesForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :category_id, :integer
  attribute :title, :string
  attribute :content

  def search_recipe
    relation = Recipe.distinct.published

    relation = relation.by_category(category_id) if category_id.present?
    title_words.each do |word|
      relation = relation.title_contain(word)
    end
    content_words.each do |word|
      relation = relation.content_contain(word)
    end
    relation
  end

  private

  def title_words
    title.present? ? title.split(nil) : []
  end

  def content_words
    content.present? ? content.split(nil) : []
  end
end
