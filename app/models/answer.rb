class Answer < ActiveRecord::Base
  include Votable
  include Commentable

  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachable, dependent: :destroy

  validates :body, :question_id, :user_id, presence: true
  validates :body, length: { minimum: 10 }
  validates_uniqueness_of :best, scope: [:question_id], conditions: -> { where(best: true) }

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  after_create :notify_subscribers

  def set_as_best
    transaction do
      Answer.where(question_id: self.question_id, best: true).update_all(best: false)
      self.update!(best: true)
    end
  end

  private

  def notify_subscribers
    QuestionNotificationJob.perform_later(self)
  end
end
