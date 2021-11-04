class Post < ApplicationRecord
	belongs_to :user
	has_many :comments, dependent: :destroy

	validates :file_post, :caption, presence: true
	serialize :file_post, Array

	mount_uploaders :file_post, PostUploader
	acts_as_votable
end
