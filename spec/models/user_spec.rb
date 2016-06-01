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
  end

  describe '.find_or_create_via_oauth' do
    let!(:user) { create(:user) }

    context 'user already has Autherization' do
      let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '1234567890') }

      it 'returns the user' do
        user.authorizations.create(provider: 'facebook', uid: '1234567890')
        expect(User.find_or_create_via_oauth(auth)).to eq user
      end
    end

    context 'user does not have Authorization' do
      let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '1234567890', info: { email: user.email }) }

      context 'user already exists' do
        it 'doesnt creates new user' do
          expect { User.find_or_create_via_oauth(auth) }.to_not change(User, :count)
        end

        it 'creates new Authorization for user' do
          expect { User.find_or_create_via_oauth(auth) }.to change(user.authorizations, :count).by(1)
        end

        it 'create new Authorization with provider and uid' do
          User.find_or_create_via_oauth(auth)
          expect(user.authorizations.first.provider).to eq auth.provider
          expect(user.authorizations.first.uid).to eq auth.uid
        end

        it 'returns the user' do
          expect(User.find_or_create_via_oauth(auth)).to eq user
        end
      end

      context 'user does not exists' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '1234567890', info: { email: 'new@user.com' }) }

        it 'creates new user' do
          expect { User.find_or_create_via_oauth(auth) }.to change(User, :count).by(1)
        end

        it 'create new user with email' do
          user = User.find_or_create_via_oauth(auth)
          expect(user.email).to eq 'new@user.com'
        end

        it 'creates new Authorization for new user' do
          user = User.find_or_create_via_oauth(auth)
          expect(user.authorizations).to_not be_empty
        end

        it 'create new Authorization with provider and uid' do
          user = User.find_or_create_via_oauth(auth)
          expect(user.authorizations.first.provider).to eq auth.provider
          expect(user.authorizations.first.uid).to eq auth.uid
        end

        it 'returns new user' do
          expect(User.find_or_create_via_oauth(auth)).to be_a(User)
        end
      end
    end
  end
end
