class PreviewsController < ApplicationController
  before_action :set_categories

  def show
    @recipe = current_user.recipes.draft.find(params[:id])
    @tags = @recipe.tags
  end
end
