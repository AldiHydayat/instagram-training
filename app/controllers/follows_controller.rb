class FollowsController < ApplicationController
  before_action :authenticate_user!, only: [:follow, :approve_toggle]

  def follow
    @user = current_user
    @following = User.friendly.find(params[:id])
    @follow = Follow.find_by(follower: @user, following: @following)

    if @follow.present?
      @follow.unfollow
    else
      Follow.follow_user(@user, @following)
    end

    redirect_to user_post_path(@following)
  end

  def follower
    @user = User.friendly.find(params[:id])

    @followers = @user.followers
  end

  def following
    @user = User.friendly.find(params[:id])

    @followings = @user.followings
  end

  def approve_toggle
    @follower = Follow.find(params[:id])
    @follower.approve_toggle
    redirect_to followers_user_path(@follower.following)
  end
end
