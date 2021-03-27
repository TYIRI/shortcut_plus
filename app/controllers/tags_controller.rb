class TagsController < ApplicationController
  skip_before_action :require_login, only: %i[show]
  before_action :set_search_recipe, only: %i[show]

  def show
    @tag = Tag.find(params[:id])
    @recipes = @tag.recipes.published.includes(:category, user: { avatar_attachment: :blob }).order(id: :desc).page(params[:page])
  end

  private

  def set_search_recipe
    @search_recipes_form = SearchRecipesForm.new
  end
end
