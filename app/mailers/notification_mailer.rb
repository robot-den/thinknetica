class NotificationMailer < ApplicationMailer
  def question_notification(question, user)
    @question = question
    mail(to: user.email, subject: 'Question take new answers!')
  end
end
