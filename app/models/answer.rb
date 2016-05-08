class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  validates :body, :question_id, :user_id, presence: true
  validates :body, length: { minimum: 10 }

  validate :only_one_best_answer_for_question

  def self.set_as_best(answer)
    old_best_answer = Answer.where(question_id: answer.question_id, best: true).first
    old_best_answer.update(best: false) unless old_best_answer.nil?
    answer.update(best: true)
  end

  def only_one_best_answer_for_question
    errors.add(:best, "best answer for question can be only one") if
      best? && Answer.where(question_id: question_id, best: true).count > 0
    end
end
