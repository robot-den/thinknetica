shared_examples_for 'API authenticable' do
  context 'unauthorized' do
    it 'return status 401 if there is no access token' do
      do_request
      expect(response.status).to eq 401
    end

    it 'return status 401 if there is invalid access token' do
      do_request(access_token: '12345')
      expect(response.status).to eq 401
    end
  end
end
