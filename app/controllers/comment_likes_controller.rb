class CommentLikesController < ApplicationController
  def create
    @comment = Comment.find(params[:comment_id])
    current_user.like_comment(@comment)
  end
  
  def destroy
    @comment = Comment.find(params[:id])
    current_user.dislike_comment(@comment)
  end
end
