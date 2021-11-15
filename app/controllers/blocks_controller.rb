class BlocksController < ApplicationController
  before_action :authenticate_user!

  def block_toggle
    @blocked_user = User.friendly.find(params[:id])
    Block.block_toggle(current_user, @blocked_user)
    redirect_to user_post_path(@blocked_user)
  end

  def blocked_user
    @blocks = current_user.blocks
  end
end
