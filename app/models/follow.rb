class Follow < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :following, class_name: "User"

  validates :follower_id, uniqueness: { scope: :following_id }
  validates :following_id, uniqueness: { scope: :follower_id }

  validate :cannot_self_follow

  def cannot_self_follow
    if follower_id.eql? following_id
      errors.add(:following_id, "can't follow self")
    end
  end

  def approve_toggle
    self.is_approved = !is_approved
    save
  end
end
