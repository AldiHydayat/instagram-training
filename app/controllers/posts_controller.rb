class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy, :like, :mypost, :repost, :liked]

  def index
    if params[:keyword].present?
      @users = User.where("name like ?", "%#{params[:keyword]}%").order(created_at: :desc)
    else
      @posts = Post.public_posts
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
      render "new"
    end
  end

  def show
    @post = Post.friendly.find(params[:id])
    @comment = Comment.new
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def like_toggle
    @post = Post.friendly.find(params[:id])
    @post.like_toggle(current_user)
    redirect_to root_path
  end

  def liked
    @posts = current_user.find_liked_items
    render "index"
  end

  def mypost
    @user = current_user
    @posts = current_user.posts.order(created_at: :desc)
  end

  def get_by_user
    @user = User.friendly.find(params[:id])
    @posts = Post.get_by_user(@user, current_user)
    render "mypost"
  end

  def repost
    @original_post = Post.friendly.find(params[:id])

    @repost = Post.repost(@original_post, current_user)
    redirect_to root_path
  end

  private

  def post_params
    params.require(:post).permit(:caption, { file_post: [] })
  end
end
