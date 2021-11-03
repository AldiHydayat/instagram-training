class PostsController < ApplicationController
	before_action :authenticate_user!, only: [:new, :create, :show, :edit, :update, :destroy]

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

	private

	def post_params
		params.require(:post).permit(:file_post, :caption)
	end
end
