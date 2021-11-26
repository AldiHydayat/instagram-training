class ArchivesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_archive, only: %i[destroy destroy_saved_post]

  def index
    @archives = Archive.get_archived_post(current_user).page(params[:page]).order(created_at: :desc)
  end

  def saved_post
    @archives = Archive.get_saved_post(current_user).page(params[:page]).order(created_at: :desc)
    render "index"
  end

  # get id archive
  def destroy
    @archive.destroy
    redirect_to root_path
  end

  private

  def set_archive
    @archive = Archive.find(params[:id])
  end
end
