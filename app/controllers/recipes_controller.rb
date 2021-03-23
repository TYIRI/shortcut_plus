class RecipesController < ApplicationController
  skip_before_action :require_login, only: %i[index show search]
  before_action :set_recipe, only: %i[edit update destroy]
  before_action :set_search_recipe, only: %i[index show my_recipes search]

  def index
    @categories = Category.all
    @ranking_recipes = Recipe.published.includes(:category, user: { avatar_attachment: :blob }).order(impressions_count: :desc).limit(5)
    @pickup_recipes = Recipe.published.includes(:category, user: { avatar_attachment: :blob }).sample(5)
  end

  def new
    @recipe = Recipe.new
  end

  def create
    @recipe = current_user.recipes.build(recipe_params)
    if params[:published]
      @recipe.status = :published
      @recipe.published_at = Time.now
    end

    if @recipe.save
      redirect_to my_recipes_path(current_user) and return if params[:draft]
      redirect_to recipe_path(@recipe)
    else
      render :new
    end
  end

  def show
    @recipe = Recipe.find(params[:id])
    redirect_to root_path if @recipe.draft?

    impressionist(@recipe, nil, unique: [:session_hash])
    @recipe_likes_count = RecipeLike.where(recipe_id: @recipe.id).count
    @comment = Comment.new
    @comments = Comment.all.includes(user: { avatar_attachment: :blob }).where(recipe_id: @recipe.id)
  end

  def edit; end

  def update
    @recipe.published_at = Time.now if params[:published] && @recipe.draft?
    if @recipe.update(recipe_params.merge(status: params_status))
      redirect_to recipe_path(@recipe) if @recipe.published?
      redirect_to my_recipes_path if @recipe.draft?
    else
      render :edit
    end
  end

  def destroy
    @recipe.destroy!
    redirect_to my_recipes_path
  end

  def my_recipes
    @published = current_user.recipes.published.includes(:category, :recipe_likes).order(id: :desc)
    @published_recipes = @published.page(params[:page]).per(2)
    @page_num_p = @published.page(params[:page]).current_page
    @draft = current_user.recipes.draft.includes(:category).order(id: :desc)
    @draft_recipes = @draft.page(params[:page]).per(2)
    @page_num_d = @draft.page(params[:page]).current_page

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
    params.require(:recipe).permit(:title, :category_id, :content, :status, :shortcut_id, :published_at)
  end

  def search_params
    params[:q]&.permit(:title, :content, :category_id)
  end

  def set_recipe
    @recipe = current_user.recipes.find(params[:id])
  end

  def set_search_recipe
    @search_recipes_form = SearchRecipesForm.new
  end

  def params_status
    if params[:published]
      :published
    elsif params[:draft]
      :draft
    end
  end
end
