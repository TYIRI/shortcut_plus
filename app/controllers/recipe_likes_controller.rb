class RecipeLikesController < ApplicationController
  def create
    recipe = Recipe.find(params[:recipe_id])
    current_user.like_recipe(recipe)
    redirect_to recipe
  end

  def destroy
    recipe = Recipe.find(params[:id])
    current_user.unlike_recipe(recipe)
    redirect_to recipe
  end
end
