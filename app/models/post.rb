class Post < ApplicationRecord
  extend FriendlyId
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :reposts, class_name: "Post", foreign_key: "repost_id", dependent: :destroy
  belongs_to :repost, class_name: "Post", optional: true

  validates :file_post, :caption, presence: true, if: :is_repost?
  serialize :file_post, Array

  mount_uploaders :file_post, PostUploader
  acts_as_votable
  friendly_id :file_post, use: :slugged

  def is_repost?
    repost_id.blank?
  end

  def like_toggle(user)
    if user.liked? self
      unliked_by user
    else
      liked_by user
    end
  end

  def self.public_posts
    posts = Post.joins(:user).where(users: { is_private: 0 }).order(created_at: :desc)
    posts = posts.select do |post|
      next true if post.repost.blank?

      !post.repost.user.is_private
    end
  end

  def self.repost(post, user)
    repost = Post.new(repost: post, user: user)
    repost.save
  end

  def self.get_by_user(user, current_user)
    return user.posts.order(created_at: :desc) if !user.is_private || user.followers.where(follower: current_user, is_approved: true).present?
  end
end
