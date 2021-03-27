class SearchRecipesForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :category_id, :integer
  attribute :title_and_content, :string

  def search_recipe
    relation = Recipe.distinct.includes(:category, user: { avatar_attachment: :blob }).published

    relation = relation.by_category(category_id) if category_id.present?
    title_and_content_words.each do |word|
      relation = relation.title_and_content_contain(word)
    end
    relation
  end

  private

  def title_and_content_words
    title_and_content.present? ? title_and_content.split(nil) : []
  end
end
