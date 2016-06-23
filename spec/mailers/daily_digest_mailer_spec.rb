# tests may fail due to time of running (questions with created_at after 23.00 does't sens to user)
require "rails_helper"

RSpec.describe DailyDigestMailer, type: :mailer do
  describe '#daily_digest' do
    let(:user) { create(:user) }
    let!(:email) { DailyDigestMailer.daily_digest(user) }
    let!(:questions) { create_list(:question, 2) }
    let!(:old_question) { create(:question, title: 'Title of the old question', created_at: Time.now - 2.days) }

    it 'delivered to the user' do
      expect(email.to[0]).to eq user.email
    end

    it 'contain titles and links for questions created by the last day' do
      questions.each do |question|
        expect(email.body).to have_content question.title
        expect(email.body).to have_link('read', href: question_url(question))
      end
    end

    it 'does not contain titles and links for questions created more than one day ago' do
      expect(email.body).to_not have_content old_question.title
      expect(email.body).to_not have_link('read', href: question_url(old_question))
    end
  end
end
