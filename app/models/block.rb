class Block < ApplicationRecord
  belongs_to :user
  belongs_to :blocked_user, class_name: "User"
  validates :user_id, :blocked_user_id, presence: true
  validate :block_self

  #   custom validate
  def block_self
    if user_id.eql? blocked_user_id
      errors.add(:blocked_user_id, "can't block self")
    end
  end

  def self.block_toggle(user, blocked_user)
    block = find_by(user: user, blocked_user: blocked_user)
    if block.present?
      block.destroy
    else
      create(user: user, blocked_user: blocked_user)
    end
  end
end
