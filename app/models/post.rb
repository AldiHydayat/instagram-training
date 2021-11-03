class Post < ApplicationRecord
	belongs_to :user
	has_many :comments

	validates :file_post, :caption, presence: true

	mount_uploader :file_post, PostUploader
	acts_as_votable
end
