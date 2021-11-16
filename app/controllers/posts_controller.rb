class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :get_by_user]
  before_action :set_post, except: [:index, :new, :create]

  def index
    if params[:keyword].present?
      @users = User.where("name like ?", "%#{params[:keyword]}%").order(created_at: :desc)
    else
      @posts = Post.public_posts(current_user)
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
    @comment = Comment.new
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def like_toggle
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
    @posts = Post.get_by_user(@user, current_user) if @user.blocks.where(blocked_user: current_user).blank?
    render "mypost"
  end

  def repost
    Post.repost(@post, current_user)
    redirect_to root_path
  end

  private

  # Callback
  def set_post
    @post = Post.friendly.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:caption, { file_post: [] })
  end
end
