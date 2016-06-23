class DailyDigestMailer < ApplicationMailer
  def daily_digest(user)
    time = Time.now.change(hour: 23)
    @questions = Question.where(created_at:  (time - 1.day)..time)
    mail(to: user.email, subject: 'Daily Digest')
  end
end
