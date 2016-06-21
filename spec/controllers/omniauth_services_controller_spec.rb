require 'rails_helper'

RSpec.describe OmniauthServicesController, type: :controller do
  describe 'get #new_email_for_oauth' do
    it 'render new_email_for_oauth view' do
      get :new_email_for_oauth
      expect(response).to render_template :new_email_for_oauth
    end
  end

  describe 'post #save_email_for_oauth' do
    context 'with valid attributes' do
      let(:save_email_for_oauth) { post :save_email_for_oauth, {email: 'test@test.com'}, {uid: '12345', provider: 'twitter'} }

      it 'redirect to sign in page' do
        save_email_for_oauth
        expect(response).to redirect_to new_user_session_path
      end

      it 'sends an email' do
        expect(OAuthMailer).to receive(:email_confirmation).and_call_original
        save_email_for_oauth
      end
    end

    context 'with invalid attributes' do
      it 'render new_email_for_oauth view' do
        post :save_email_for_oauth, email: ''
        expect(response).to render_template :new_email_for_oauth
      end
    end
  end

  describe 'get #confirm_email' do
    context 'with valid attributes' do
      let!(:auth) { create(:authorization) }
      let!(:old_hash) { auth.confirmation_hash }
      before { get :confirm_email, token: auth.confirmation_hash }

      it 'set authorization confirmed status true' do
        auth.reload
        expect(auth.confirmed).to eq true
      end

      it 'change authorization confirmation hash' do
        auth.reload
        expect(auth.confirmation_hash).to_not eq old_hash
      end

      it 'redirect to login with provider' do
        expect(response).to redirect_to "/users/auth/#{auth.provider}"
      end
    end

    context 'with invalid attributes' do
      it 'redirect to login with provider' do
        get :confirm_email, provider: nil, uid: nil, token: nil
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
