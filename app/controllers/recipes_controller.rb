class RecipesController < ApplicationController
  skip_before_action :require_login, only: %i[index show search]
  before_action :set_search_recipe, only: %i[index show my_recipes search]

  def index
    @categories = Category.all
  end

  def show
    @recipe = Recipe.find(params[:id])
    @recipe_likes_count = RecipeLike.where(recipe_id: @recipe.id).count
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

  def my_recipes
    @published = current_user.recipes.published.includes(:category).order(id: :desc)
    @published_recipes = @published.page(params[:page]).per(1)
    @draft = current_user.recipes.draft.includes(:category).order(id: :desc)
    @draft_recipes = @draft.page(params[:page]).per(1)

    # Ajax通信のみ通過
    return unless request.xhr?

    case params[:type]
    when 'published_recipes', 'draft_recipes'
      render "recipes/#{params[:type]}"
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
