class PreviewsController < ApplicationController
  def show
    @recipe = current_user.recipes.draft.find(params[:id])
    @tags = @recipe.tags
  end
end
