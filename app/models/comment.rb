class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :commentable, polymorphic: true, touch: true

  validates :user_id, presence: true
  validates :body, presence: true
  validates :body, length: { minimum: 5 }
end
