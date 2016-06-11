require 'rails_helper'

describe 'Profile API' do
  describe 'GET /me' do
    context 'unauthorized' do
      it 'return status 401 if there is no access token' do
        get '/api/v1/profiles/me', format: :json
        expect(response.status).to eq 401
      end

      it 'return status 401 if there is invalid access token' do
        get '/api/v1/profiles/me', format: :json, access_token: '12345'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', format: :json, access_token: access_token.token }

      it 'return status 200' do
        expect(response.status).to eq 200
      end

      %w{email id created_at updated_at}.each do |key|
        it "respond contains #{key}" do
          expect(response.body).to be_json_eql(me.send(key.to_sym).to_json).at_path(key)
        end
      end

      %w{password encrypted_password}.each do |key|
        it "respond does not contain #{key}" do
          expect(response.body).to_not have_json_path(key)
        end
      end
    end
  end

  describe 'GET /all' do
    context 'unauthorized' do
      it 'return status 401 if there is no access token' do
        get '/api/v1/profiles/all', format: :json
        expect(response.status).to eq 401
      end

      it 'return status 401 if there is invalid access token' do
        get '/api/v1/profiles/all', format: :json, access_token: '12345'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let!(:users) { create_list(:user, 3) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/all', format: :json, access_token: access_token.token }

      it 'return status 200' do
        expect(response.status).to eq 200
      end

      it 'does not contain current user' do
        expect(response.body).to_not include_json(me.to_json)
      end

      it 'respond contain all users (except me)' do
        expect(response.body).to be_json_eql(users.to_json)
      end

      it 'respond contain correct count of records' do
        expect(response.body).to have_json_size(3).at_path('/')
      end

      %w{email id created_at updated_at}.each do |key|
        it "json for each user from list contains #{ key }" do
          users.each_with_index do |user, i|
            expect(response.body).to be_json_eql(user.send(key.to_sym).to_json).at_path("#{ i }/#{ key }")
          end
        end
      end

      %w{password encrypted_password}.each do |key|
        it "json for each user from list does not contain #{ key }" do
          users.each_with_index do |user, i|
            expect(response.body).to_not have_json_path("#{ i }/#{ key }")
          end
        end
      end
    end
  end
end
