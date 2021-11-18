class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  extend FriendlyId

  before_create :titleize_name
  before_save :titleize_name

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, :username, presence: true
  validates :username, uniqueness: true

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :followers, class_name: "Follow", foreign_key: :following_id, dependent: :destroy
  has_many :followings, class_name: "Follow", foreign_key: :follower_id, dependent: :destroy
  has_many :blocks, dependent: :destroy
  has_many :blocked_users, class_name: "Block", foreign_key: :blocked_user_id, dependent: :destroy

  acts_as_voter
  friendly_id :name, use: :slugged

  private

  def titleize_name
    self.name = name.titleize
  end
end
