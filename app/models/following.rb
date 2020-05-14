class Following < ApplicationRecord
  belongs_to :user, touch: true
  belongs_to :followed_user, class_name: 'User'

  validates :user_id, :uniqueness => {:scope => :followed_user_id,
                                    :message => 'Already friended!'}
end
