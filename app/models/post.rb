class Post < ApplicationRecord
  extend FriendlyId
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :reposts, class_name: 'Post', foreign_key: 'repost_id', dependent: :destroy
  belongs_to :repost, class_name: 'Post', optional: true

  validates :file_post, :caption, presence: true, if: :is_repost?
  serialize :file_post, Array

  mount_uploaders :file_post, PostUploader
  acts_as_votable
  friendly_id :file_post, use: :slugged

  def like_toggle(user)
    if user.liked? self
      unliked_by user
    else
      liked_by user
    end
  end

  def self.public_posts(current_user)
    if current_user
      # jika login
      block_list = []

      current_user.blocks.pluck(:blocked_user_id).each { |val| block_list << val }

      current_user.blocked_users.pluck(:user_id).each { |val| block_list << val }

      user = User.includes(:followers).where('users.is_private = ? or users.id = ?', false, current_user)
                 .or(includes(:followers).where(follows: { follower_id: current_user, is_approved: true }))

      # menseleksi lagi jika block list tidak kosong
      user = user.where('users.id not in (?)', block_list) if block_list.present?

      filter_post(user)
      # jika tidak login
    else
      user = User.where(is_private: false)

      filter_post(user)
    end

    # posts = includes(user: [:blocks])
    #   .where(users: { is_private: false })
    #   .where.not(blocks: { blocked_user_id: current_user })
    #   .or(includes(user: [:blocks]).where(blocks: { blocked_user_id: nil }))
    #   .references(:users)
  end

  def self.repost(post, user)
    repost = new(repost: post, user: user)
    repost.save
  end

  def self.get_by_user(user, current_user)
    return user.posts.order(created_at: :desc) if !user.is_private || user.followers.where(follower: current_user,
                                                                                           is_approved: true).present? || user == current_user
  end

  private

  def is_repost?
    repost_id.blank?
  end

  def self.filter_post(user)
    posts = where(user_id: user.pluck(:id))

    posts.select do |post|
      next true if post.repost.blank?

      !post.repost.user.is_private
    end
  end
end
