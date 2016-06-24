require "rails_helper"

RSpec.describe NotificationMailer, type: :mailer do
  describe '#question_notification' do
    let(:question) { create(:question) }
    let!(:email) { NotificationMailer.question_notification(question, question.user) }

    it 'delivered to the user' do
      expect(email.to[0]).to eq question.user.email
    end

    it 'contain link to updated question' do
      expect(email.body).to have_link('check', href: question_url(question))
    end
  end
end
