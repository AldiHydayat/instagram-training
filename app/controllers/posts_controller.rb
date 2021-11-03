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
		@post.user = current_user
		if @post.save
			redirect_to root_path
		else
			render 'new'
		end
	end

	def show
		@post = Post.find(params[:id])
		@comment = Comment.new
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
