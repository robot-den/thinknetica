class DailyDigestMailer < ApplicationMailer
  def daily_digest(user)
    @questions = Question.where(created_at:  Time.zone.now.yesterday.all_day)
    mail(to: user.email, subject: 'Daily Digest')
  end
end
