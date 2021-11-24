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
  has_many :archives, dependent: :destroy

  acts_as_voter
  friendly_id :name, use: :slugged

  scope :public_users, -> { where(is_private: false) }

  def block_list
    list = []
    blocks.pluck(:blocked_user_id).each { |val| list << val unless list.include?(val) }
    blocked_users.pluck(:user_id).each { |val| list << val unless list.include?(val) }
    list
    # mengembalikan id user yang diblock dan memblokir
  end

  def self.available_user(current_user, list)
    # mengembalikan user yang public atau sudah di approve
    users = includes(:followers).where("users.is_private = ? or users.id = ?", false, current_user)
      .or(includes(:followers).where(follows: { follower_id: current_user, is_approved: true }))

    users = users.where("users.id not in (?)", list) if list.present?

    users
  end

  def self.search_user(keyword)
    @users = User.where("name like ?", "%#{keyword}%").order(created_at: :desc)
  end

  private

  def titleize_name
    self.name = name.titleize
  end
end
