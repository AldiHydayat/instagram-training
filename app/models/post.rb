class Post < ApplicationRecord
	belongs_to :user
	has_many :comments

	mount_uploader :file_post, PostUploader
	acts_as_votable
end
