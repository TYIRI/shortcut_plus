class CommentsController < ApplicationController
  def create
    @comment = current_user.comments.build(comment_params)
    if @comment.save
      @comments = Comment.all.includes(user: { avatar_attachment: :blob }).where(recipe_id: params[:recipe_id])
      redirect_to recipe_path(@comment.recipe)
    else
      @recipe = Recipe.find(params[:recipe_id])
      @comments = Comment.all.includes(user: { avatar_attachment: :blob }).where(recipe_id: @recipe.id)
    end
  end

  def destroy
    @comment = current_user.comments.find(params[:id])
    @comment.destroy!
    @comments = Comment.all.includes(user: { avatar_attachment: :blob }).where(recipe_id: @comment.recipe_id)
    redirect_to recipe_path(@comment.recipe)
  end

  private

  def comment_params
    params.require(:comment).permit(:content).merge(recipe_id: params[:recipe_id])
  end
end
