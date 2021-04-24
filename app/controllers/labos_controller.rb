class LabosController < ApplicationController
  skip_before_action :require_login, only: %i[show]
  before_action :set_categories

  def show
    @user = User.find_by(name: params[:id])
    @recipes = @user.recipes.published.includes(:category).order(id: :desc).page(params[:page])
  end
end
