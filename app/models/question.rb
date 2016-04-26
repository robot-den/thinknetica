class Question < ActiveRecord::Base
  validates :title, :body, presence: true
  validates :title, :body, length: { minimum: 10 }
end
