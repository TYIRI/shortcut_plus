class RecipesController < ApplicationController
  skip_before_action :require_login, only: %i[index show]

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

  private

  def recipe_params
    params.require(:recipe).permit(:title, :category_id, :content, :status, :shortcut_id)
  end
end
