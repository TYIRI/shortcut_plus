class RecipesController < ApplicationController
  skip_before_action :require_login, only: %i[index show search]
  before_action :set_search_recipe, only: %i[index show search]

  def index; end

  def show
    @recipe = Recipe.find(params[:id])
    @comment = Comment.new
    @comments = Comment.all.includes(:user).where(recipe_id: @recipe.id)
  end

  def new
    @recipe = Recipe.new
  end

  def create
    @recipe = current_user.recipes.build(recipe_params)
    @recipe.status = :published if params[:published]
    if @recipe.save
      redirect_to my_recipe_path(current_user) if params[:draft]
      redirect_to recipe_path(@recipe)
    else
      render :new
    end
  end

  def search
    @search_recipes_form = SearchRecipesForm.new(search_params)
    @recipes = @search_recipes_form.search_recipe.order(id: :desc).page(params[:page])
  end

  private

  def recipe_params
    params.require(:recipe).permit(:title, :category_id, :content, :status, :shortcut_id)
  end

  def search_params
    params[:q]&.permit(:title, :content, :category_id)
  end

  def set_search_recipe
    @search_recipes_form = SearchRecipesForm.new
  end
end
