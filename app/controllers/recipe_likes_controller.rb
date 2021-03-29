class RecipeLikesController < ApplicationController
  def create
    @recipe = Recipe.find(params[:recipe_id])
    current_user.like_recipe(@recipe)
    @recipe_likes_count = RecipeLike.where(recipe_id: @recipe.id).count
  end

  def destroy
    @recipe = Recipe.find(params[:id])
    current_user.dislike_recipe(@recipe)
    @recipe_likes_count = RecipeLike.where(recipe_id: @recipe.id).count
  end
end
