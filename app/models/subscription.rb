class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :subscriptable, polymorphic: true

  validates :user_id, presence: true
  validates :user_id, uniqueness: { scope: [:subscriptable_id, :subscriptable_type] }
end
