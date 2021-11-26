class PostsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show get_by_user]
  before_action :set_post, except: %i[index new create mypost get_by_user liked]
  before_action :is_post_archive?, only: %i[show]

  def index
    if params[:keyword].present?
      @users = User.search_user(params[:keyword])
      if current_user
        block_list = current_user.block_list
        @users = @users.where.not(id: block_list)
      end
    else
      @posts = Post.public_posts(current_user, params[:page])
      # respond_to do |format|
      #   format.html
      #   format.js
      # end
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

  def edit; end

  def update; end

  def destroy
    @post.remove_file_post
    @post.destroy
    redirect_to mypost_posts_path
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
    @posts = current_user.posts.where(is_archived: false).order(created_at: :desc).page(params[:page])
    respond_to do |format|
      format.html
      format.js { render :"index" }
    end
  end

  def get_by_user
    @user = User.friendly.find(params[:id])
    @posts = Post.get_by_user(@user, current_user, params[:page]) if @user.blocks.where(blocked_user: current_user).blank?
    respond_to do |format|
      format.html { render :"mypost" }
      format.js { render :"index" }
    end
  end

  def repost
    Post.repost(@post, current_user)
    redirect_to root_path
  end

  def archive_post
    Archive.archive_post(@post)
    redirect_to root_path
  end

  def save_post
    Archive.save_post(@post, current_user)
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

  def is_post_archive?
    if @post.is_archived && @post.user != current_user
      redirect_to root_path, notice: "Postingan tidak ditemukan"
    end
  end
end
