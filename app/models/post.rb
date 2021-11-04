class Post < ApplicationRecord
	belongs_to :user
	has_many :comments, dependent: :destroy
	has_many :reposts, class_name: "Post", foreign_key: "repost_id", dependent: :destroy
	belongs_to :repost, class_name: "Post", optional: true

	validates :file_post, :caption, presence: true
	serialize :file_post, Array

	mount_uploaders :file_post, PostUploader
	acts_as_votable
end
