class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy

  validates :title, :body, presence: true
  validates :title, :body, length: { minimum: 10 }
end
