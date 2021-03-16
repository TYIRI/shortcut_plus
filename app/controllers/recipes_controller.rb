class RecipesController < ApplicationController
  skip_before_action :require_login, only: %i[index show]

  def index; end
end
