class CommentsController < ApplicationController
	before_action: :authenticate_user!, only: [:create]

	def create
		@post = Post.find(params[:post_id])
		@comment = Comment.new(comment_params)
		@comment.user = current_user
		@comment.post = @post
		@comment.save

		redirect_to post_path(@post)
	end

	private

	def comment_params
		params.require(:comment).permit(:comment)
	end
end
