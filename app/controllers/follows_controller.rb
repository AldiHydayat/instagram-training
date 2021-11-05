class FollowsController < ApplicationController
    before_action :authenticate_user!, only: [:follow]

    def follow
        @user = current_user
        @following = User.find(params[:id])
        @follow = Follow.find_by(follower: @user, following: @following)

        if @follow.present?
            @follow.destroy
            @follow.save
            redirect_to user_post_path(@following)
        else
            @follow = Follow.new(follower: @user, following: @following)
            @follow.save
            redirect_to user_post_path(@following)
        end
    end
end
