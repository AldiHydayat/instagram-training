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

  def self.public_posts(current_user)
    posts = includes(:user).where(users: { is_private: 0 }).order(created_at: :desc)

    # jika tidak login
    return posts if current_user.nil?

    posts.select do |post|
      # skip dengan return false jika current_user diblock atau current_user memblokir
      next false if current_user.blocks.where(blocked_user: post.user).present? || post.user.blocks.where(blocked_user: current_user).present?

      # skip dengan true jika bukan repost
      next true if post.repost.blank?

      # menyeleksi repost yang usernya public dan current user tidak diblock dan tidak memblokir
      !post.repost.user.is_private
    end
  end

  def self.repost(post, user)
    repost = new(repost: post, user: user)
    repost.save
  end

  def self.get_by_user(user, current_user)
    return user.posts.order(created_at: :desc) if !user.is_private || user.followers.where(follower: current_user, is_approved: true).present? || user == current_user
  end
end
