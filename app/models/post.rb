class Post < ApplicationRecord
  extend FriendlyId
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :reposts, class_name: "Post", foreign_key: "repost_id", dependent: :destroy
  has_many :archives, dependent: :destroy
  belongs_to :repost, class_name: "Post", optional: true

  validates :file_post, :caption, presence: true, if: :is_repost?
  serialize :file_post, Array

  mount_uploaders :file_post, PostUploader
  acts_as_votable
  friendly_id :file_post, use: :slugged

  scope :get_archived_post, ->(user) { where(user: user, is_archived: true) }

  def like_toggle(user)
    if user.liked? self
      unliked_by user
    else
      liked_by user
    end
  end

  def self.public_posts(current_user)
    block_list = []

    if current_user
      # jika login
      block_list = current_user.block_list

      users = User.available_user(current_user, block_list)
    else
      # jika tidak login
      users = User.public_users
    end

    filter_post(users, current_user, block_list)
  end

  def self.repost(post, user)
    repost = new(repost: post, user: user)
    repost.save
  end

  def self.get_by_user(user, current_user)
    if !user.is_private || user.followers.where(follower: current_user, is_approved: true).present? || user == current_user
      user.posts.where(is_archived: false).order(created_at: :desc)
    end
  end

  def is_repost_user_approved?(current_user)
    repost.user.followers.where(follower_id: current_user, is_approved: true).present?
  end

  private

  def is_repost?
    repost_id.blank?
  end

  def self.filter_post(users, current_user, block_list = [])
    posts = where(user_id: users.pluck(:id), is_archived: false).order(created_at: :desc)

    posts.select do |post|
      next true if post.repost.blank?

      # false jika repost.user masuk block_list
      next false if block_list.include?(post.repost.user.id)

      # true jika repost.user sudah difollow current_user dan diapprove
      next true if post.is_repost_user_approved?(current_user)

      # check jika repost.user tidak private
      !post.repost.user.is_private
    end
  end
end
