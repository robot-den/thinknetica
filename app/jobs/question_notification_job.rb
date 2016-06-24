class QuestionNotificationJob < ActiveJob::Base
  queue_as :mailers

  def perform(answer)
    question = answer.question
    question.subscriptions.each do |subscription|
      NotificationMailer.question_notification(question, subscription.user).deliver_later
    end
  end
end
