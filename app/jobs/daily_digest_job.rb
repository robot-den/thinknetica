class DailyDigestJob < ActiveJob::Base
  queue_as :mailers

  def perform
    User.find_each.each { |user| DailyDigestMailer.daily_digest(user).deliver_later }
  end
end
