class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  validates :body, :question_id, :user_id, presence: true
  validates :body, length: { minimum: 10 }

  validates_uniqueness_of :best, scope: [:question_id], conditions: -> { where(best: true) }
  # # не завелось
  # # validates :best, uniqueness: { scope: :question_id, conditions: -> { where(best: true) } }

  def set_as_best
    transaction do
      Answer.where(question_id: self.question_id, best: true).update_all(best: false)
      self.update(best: true)
    end
  end
end
