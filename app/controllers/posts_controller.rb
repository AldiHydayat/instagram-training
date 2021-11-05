class PostsController < ApplicationController
	before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy, :like, :mypost, :repost, :liked]

	def index
		if params[:keyword] && params[:keyword] != ''
			@users = User.where('name like ?', "%#{params[:keyword]}%").order(created_at: :desc)
		else
			@posts = Post.all.order(created_at: :desc)
		end
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

	def liked
		@posts = current_user.find_liked_items
		render 'index'
	end

	def mypost
		@posts = Post.where(user: current_user).order(created_at: :desc)
	end

	def get_by_user
		@posts = Post.where(user: params[:id]).order(created_at: :desc)
		render 'mypost'
	end

	def repost
		@original_post = Post.find(params[:id])

		@repost = Post.new(file_post: @original_post.file_post, caption: @original_post.caption, repost_id: @original_post.id, user: current_user);
		@repost.save
		redirect_to root_path
	end

	private

	def post_params
		params.require(:post).permit(:caption, {file_post: []})
	end
end
