class CommentsController < ApplicationController
  before_action :authenticate_user!, only: %i[create reply]

  def create
    @post = Post.friendly.find(params[:post_id])
    @comment = Comment.new(comment_params)
    @comment.user = current_user
    @comment.post = @post
    @comment.save

    redirect_to post_path(@post)
  end

  def reply
    @post = Post.friendly.find(params[:post_id])
    @comment = Comment.find(params[:id])
    @reply = Comment.new(comment_params)
    @reply.user = current_user
    @reply.post = @post
    @reply.reply = @comment
    if @reply.save
      redirect_to post_path(@post)
    else
      redirect_to post_path(@post)
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:comment)
  end
end
