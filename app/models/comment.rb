class Comment < ApplicationRecord
	belongs_to :user
	belongs_to :post
	has_many :replys, class_name: "Comment", foreign_key: "reply_id", dependent: :destroy
	belongs_to :reply, class_name: "Comment", optional: true
end
