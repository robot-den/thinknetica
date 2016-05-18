class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :user_id, presence: true
  validates :value, presence: true
  validates :value, inclusion: { in: -1..1 }
  validates :user_id, uniqueness: { scope: [:votable_id, :votable_type] }
end
