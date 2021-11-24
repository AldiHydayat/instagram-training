class Archive < ApplicationRecord
  after_create :update_post_to_archived
  after_destroy :update_post_to_unarchive

  belongs_to :post
  belongs_to :user, optional: true
  enum status: [:saved, :archive]

  validates :post_id, presence: true
  validates :user_id, presence: true, if: :is_status_saved?

  scope :get_archived_post, ->(user) { includes(:post).where(posts: { user: user }, status: :archive) }
  scope :get_saved_post, ->(user) { where(user: user, status: :saved) }

  def self.archive_post(post)
    create(post: post, status: :archive)
  end

  def self.save_post(post, user)
    create(post: post, user: user, status: :saved)
  end

  private

  def is_status_saved?
    self.status == "saved"
  end

  def update_post_to_archived
    if status == "archive"
      post.update(is_archived: true)
    end
  end

  def update_post_to_unarchive
    if status == "archive"
      post.update(is_archived: false)
    end
  end
end
