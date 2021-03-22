class CategoriesController < ApplicationController
  skip_before_action :require_login, only: %i[show]
  before_action :set_search_recipe, only: %i[show]

  def show
    @category = Category.find(params[:id])
    @recipes = Recipe.published.includes(:user).where(category_id: params[:id]).order(id: :desc).page(params[:page])
  end

  private

  def set_search_recipe
    @search_recipes_form = SearchRecipesForm.new
  end
end
