require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do
  let(:users) { create_list(:user, 2) }
  it 'sends mail' do
    users.each { |user| expect(DailyDigestMailer).to receive(:daily_digest).with(user).and_call_original }
    DailyDigestJob.perform_now
  end
end
