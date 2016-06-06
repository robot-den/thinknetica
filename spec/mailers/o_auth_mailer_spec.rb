require "rails_helper"

RSpec.describe OAuthMailer, type: :mailer do
  describe '#email_confirmation' do
    let(:authorization) { create(:authorization) }
    let!(:email) { OAuthMailer.email_confirmation(authorization) }

    it 'delivered to the user of authorization' do
      expect(email.to[0]).to eq authorization.user.email
    end

    it 'send mail with confirmation link' do
      expect(email.body).to have_link('Confirm my email', href: "#{confirm_email_url}?token=#{authorization.confirmation_hash}")
    end
  end
end
