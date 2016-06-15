require 'rails_helper'

describe 'Profile API' do
  describe 'GET #index' do
    context 'unauthorized' do
      it 'return status 401 if there is no access token' do
        get '/api/v1/questions', format: :json
        expect(response.status).to eq 401
      end

      it 'return status 401 if there is invalid access token' do
        get '/api/v1/questions', format: :json, access_token: '12345'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      let!(:questions) { create_list(:question, 3) }
      let!(:answer) { create(:answer, question: questions.first)}

      before { get '/api/v1/questions', format: :json, access_token: access_token.token }

      it 'return status 200' do
        expect(response.status).to eq 200
      end

      it 'respond contain all questions' do
        expect(response.body).to have_json_size(3).at_path('questions')
      end

      %w{title body id created_at updated_at}.each do |key|
        it "json for each question from list contains #{ key }" do
          questions.each_with_index do |question, i|
            expect(response.body).to be_json_eql(question.send(key.to_sym).to_json).at_path("questions/#{ i }/#{ key }")
          end
        end
      end
    end
  end

  describe 'GET #show' do
    context 'unauthorized' do
      it 'return status 401 if there is no access token' do
        get '/api/v1/questions/1', format: :json
        expect(response.status).to eq 401
      end

      it 'return status 401 if there is invalid access token' do
        get '/api/v1/questions/1', format: :json, access_token: '12345'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      let!(:question) { create(:question, :with_attachment) }
      let!(:comment) { create(:comment, commentable: question) }
      let(:attachment) { question.attachments.first }

      before { get "/api/v1/questions/#{ question.id }", format: :json, access_token: access_token.token }

      it 'return status 200' do
        expect(response.status).to eq 200
      end

      %w{title body id created_at updated_at}.each do |key|
        it "json for question contains #{ key }" do
          expect(response.body).to be_json_eql(question.send(key.to_sym).to_json).at_path("question/#{ key }")
        end
      end

      context 'comments' do
        it 'question contain its comments' do
          expect(response.body).to have_json_size(1).at_path('question/comments')
        end

        %w{body id created_at updated_at}.each do |key|
          it "json for comment contains #{ key }" do
            expect(response.body).to be_json_eql(comment.send(key.to_sym).to_json).at_path("question/comments/0/#{ key }")
          end
        end
      end

      context 'attachments' do
        it 'question contain its attachments' do
          expect(response.body).to have_json_size(1).at_path('question/attachments')
        end

        it "json for attachment contains url" do
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("question/attachments/0/url")
        end

        it "json for attachment contains id" do
          expect(response.body).to be_json_eql(attachment.id.to_json).at_path("question/attachments/0/id")
        end
      end
    end
  end

  describe 'GET #answers' do
    context 'unauthorized' do
      it 'return status 401 if there is no access token' do
        get '/api/v1/questions/1/answers', format: :json
        expect(response.status).to eq 401
      end

      it 'return status 401 if there is invalid access token' do
        get '/api/v1/questions/1/answers', format: :json, access_token: '12345'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      let!(:question) { create(:question) }
      let!(:answers) { create_list(:answer, 2, question: question) }

      before { get "/api/v1/questions/#{ question.id }/answers", format: :json, access_token: access_token.token }

      it 'return status 200' do
        expect(response.status).to eq 200
      end

      it 'respond contains all answers of question' do
        puts response.body
        expect(response.body).to have_json_size(2).at_path('answers')
      end

      %w{body id created_at updated_at}.each do |key|
        it "json for each answer from list contains #{ key }" do
          answers.each_with_index do |answer, i|
            expect(response.body).to be_json_eql(answer.send(key.to_sym).to_json).at_path("answers/#{ i }/#{ key }")
          end
        end
      end
    end
  end
end
