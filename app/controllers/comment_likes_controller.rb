class CommentLikesController < ApplicationController
  def create
    comment = Comment.find(params[:comment_id])
    current_user.like_comment(comment)
    redirect_to comment.recipe
  end

  def destroy
    comment = Comment.find(params[:id])
    current_user.unlike_comment(comment)
    redirect_to comment.recipe
  end
end
