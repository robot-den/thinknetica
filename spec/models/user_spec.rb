require 'rails_helper'

RSpec.describe User, type: :model do
  context 'validations' do
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
    it { should have_many(:questions).dependent(:destroy) }
    it { should have_many(:answers).dependent(:destroy) }
    it { should have_many(:votes).dependent(:destroy) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many(:authorizations).dependent(:destroy) }
    it { should have_many(:subscriptions).dependent(:destroy) }
  end

  describe '.find_or_create_authorization' do
    let!(:user) { create(:user) }

    it 'return nil if email is nil' do
      auth = OmniAuth::AuthHash.new(provider: 'facebook', uid: '1234567890', info: { email: nil })
      expect(User.find_or_create_authorization(auth)).to eq nil
    end

    context 'user already has Autherization' do
      let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '1234567890') }

      it 'returns the authorization' do
        authorization = user.authorizations.create(provider: 'facebook', uid: '1234567890')
        expect(User.find_or_create_authorization(auth)).to eq authorization
      end
    end

    context 'user does not have Authorization' do
      let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '1234567890', info: { email: user.email }) }

      context 'user already exists' do
        it 'doesnt creates new user' do
          expect { User.find_or_create_authorization(auth) }.to_not change(User, :count)
        end

        it 'creates new Authorization for user' do
          expect { User.find_or_create_authorization(auth) }.to change(user.authorizations, :count).by(1)
        end

        it 'create new Authorization with provider and uid' do
          User.find_or_create_authorization(auth)
          expect(user.authorizations.first.provider).to eq auth.provider
          expect(user.authorizations.first.uid).to eq auth.uid
        end

        it 'returns the authorization' do
          expect(User.find_or_create_authorization(auth)).to be_a(Authorization)
        end
      end

      context 'user does not exists' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '1234567890', info: { email: 'new@user.com' }) }

        it 'creates new user' do
          expect { User.find_or_create_authorization(auth) }.to change(User, :count).by(1)
        end

        it 'create new user with email' do
          user = User.find_or_create_authorization(auth).user
          expect(user.email).to eq 'new@user.com'
        end

        it 'creates new Authorization for new user' do
          user = User.find_or_create_authorization(auth).user
          expect(user.authorizations).to_not be_empty
        end

        it 'create new Authorization with provider and uid' do
          user = User.find_or_create_authorization(auth).user
          expect(user.authorizations.first.provider).to eq auth.provider
          expect(user.authorizations.first.uid).to eq auth.uid
        end

        it 'returns new authorization' do
          expect(User.find_or_create_authorization(auth)).to be_a(Authorization)
        end
      end
    end
  end
end
