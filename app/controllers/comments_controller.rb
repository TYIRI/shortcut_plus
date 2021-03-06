class CommentsController < ApplicationController
  def create
    @comment = current_user.comments.build(comment_params)
    if @comment.save
      @comment.recipe.create_notification_comment(current_user, @comment.id)
      render :create
    else
      render :error
    end
  end

  def update
    @comment = current_user.comments.find(params[:id])
    if @comment.update(comment_update_params)
      render json: { comment: @comment, content: @comment.content }, status: :ok
    else
      render json: { comment: @comment, errors: { messages: @comment.errors.full_messages } }, status: :bad_request
    end
  end

  def destroy
    @comment = current_user.comments.find(params[:id])
    @comment.destroy!
  end

  private

  def comment_params
    params.require(:comment).permit(:content).merge(recipe_id: params[:recipe_id])
  end

  def comment_update_params
    params.require(:comment).permit(:content)
  end
end
