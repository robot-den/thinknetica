require 'rails_helper'

RSpec.describe Authorization, type: :model do
  context 'validations' do
    it { should validate_presence_of :provider }
    it { should validate_presence_of :uid }
    it { should validate_presence_of :user_id }
    it { should belong_to(:user) }
  end

  describe '.need_confirm?' do
    it 'return true if authorization provider is in list and unconfirmed' do
      authorization = create(:authorization)
      expect(authorization.need_confirm?).to eq true
    end

    it 'return false if authorization provider is not in the list' do
      authorization = create(:authorization, provider: 'facebook')
      expect(authorization.need_confirm?).to eq false
    end

    it 'return false if authorization provider is in list and confirmed' do
      authorization = create(:authorization, confirmed: true)
      expect(authorization.need_confirm?).to eq false
    end
  end
end
