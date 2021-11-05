class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, :username, presence: true
  validates :username, uniqueness: true

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :followers, class_name: "Follow", foreign_key: :following_id, dependent: :destroy
  has_many :followings, class_name: "Follow", foreign_key: :follower_id, dependent: :destroy
  acts_as_voter
end
