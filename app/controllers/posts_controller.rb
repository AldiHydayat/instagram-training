class PostsController < ApplicationController
	before_action :authenticate_user!, only: [:new, :create, :show, :edit, :update, :destroy, :like]

	def index
		@posts = Post.all
	end

	def new
		@post = Post.new
	end

	def create
		@post = Post.new(post_params)
		# render plain: @post.inspect
		@post.user = current_user
		@post.save
		redirect_to root_path
	end

	def show
		
	end

	def edit
		
	end

	def update
		
	end

	def destroy
		
	end

	def like
		@post = Post.find(params[:id])
		if current_user.liked? @post
			@post.unliked_by current_user
		else
			@post.liked_by current_user
		end
		redirect_to root_path
	end

	private

	def post_params
		params.require(:post).permit(:file_post, :caption)
	end
end
