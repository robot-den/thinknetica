class Answer < ActiveRecord::Base
  belongs_to :question

  validates :body, presence: true
  validates :body, length: { minimum: 10 }
  validates :question, presence: true
end
