class User < ApplicationRecord
  has_many :user_videos, dependent: :destroy
  has_many :videos, through: :user_videos

  has_many :followings
  has_many :followed_users, through: :followings

  has_many :followers, foreign_key: :followed_user_id, class_name: 'Following'
  has_many :follower_users, through: :followers, source: :user

  validates :email, uniqueness: true, presence: true
  validates :password, presence: true, on: :creation
  validates :first_name, presence: true
  enum role: { default: 0, admin: 1 }
  has_secure_password

  def friends
     self.followings + self.followers
  end

  def sorted_videos
    videos.sort { |a,b| a.tutorial_id <=> b.tutorial_id} 
  end
end
