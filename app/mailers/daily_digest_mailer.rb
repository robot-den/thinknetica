class DailyDigestMailer < ApplicationMailer
  def daily_digest(user)
    @questions = Question.where('created_at > ?', Time.now - 1.day)
    mail(to: user.email, subject: 'Daily Digest')
  end
end
