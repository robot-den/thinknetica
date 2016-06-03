class OAuthMailer < ApplicationMailer
  def email_confirmation(authorization)
    @url = "#{confirm_email_url}?provider=#{authorization.provider}&uid=#{authorization.uid}&token=#{authorization.confirmation_hash}"
    mail(to: authorization.user.email, subject: 'Confirm your email for qna')
  end
end
