require 'rails_helper'

describe 'Profile API' do
  let(:me) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: me.id) }

  describe 'GET /me' do
    it_behaves_like 'API authenticable'

    context 'authorized' do
      before { get '/api/v1/profiles/me', format: :json, access_token: access_token.token }

      it 'return status 200' do
        expect(response.status).to eq 200
      end

      %w{email id created_at updated_at admin}.each do |key|
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

    def do_request(options = {})
      get '/api/v1/profiles/me', { format: :json }.merge(options)
    end
  end

  describe 'GET /all' do
    it_behaves_like 'API authenticable'

    context 'authorized' do
      let!(:users) { create_list(:user, 3) }

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

      %w{email id created_at updated_at admin}.each do |key|
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

    def do_request(options = {})
      get '/api/v1/profiles/all', { format: :json }.merge(options)
    end
  end
end
