require 'rails_helper'


describe 'Answers API' do
  describe 'GET #show' do
    context 'unauthorized' do
      it 'return status 401 if there is no access token' do
        get '/api/v1/answers/1', format: :json
        expect(response.status).to eq 401
      end

      it 'return status 401 if there is invalid access token' do
        get '/api/v1/answers/1', format: :json, access_token: '12345'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      let!(:answer) { create(:answer, :with_attachment) }
      let!(:comment) { create(:comment, commentable: answer) }
      let(:attachment) { answer.attachments.first }

      before { get "/api/v1/answers/#{ answer.id }", format: :json, access_token: access_token.token }

      it 'return status 200' do
        expect(response.status).to eq 200
      end

      %w{body id created_at updated_at}.each do |key|
        it "json for answer contains #{ key }" do
          expect(response.body).to be_json_eql(answer.send(key.to_sym).to_json).at_path("answer/#{ key }")
        end
      end

      context 'comments' do
        it 'answer contain its comments' do
          expect(response.body).to have_json_size(1).at_path('answer/comments')
        end

        %w{body id created_at updated_at}.each do |key|
          it "json for comment contains #{ key }" do
            expect(response.body).to be_json_eql(comment.send(key.to_sym).to_json).at_path("answer/comments/0/#{ key }")
          end
        end
      end

      context 'attachments' do
        it 'answer contain its attachments' do
          expect(response.body).to have_json_size(1).at_path('answer/attachments')
        end

        it "json for attachment contains url" do
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("answer/attachments/0/url")
        end

        it "json for attachment contains id" do
          expect(response.body).to be_json_eql(attachment.id.to_json).at_path("answer/attachments/0/id")
        end
      end
    end
  end

  describe 'POST #create' do
    context 'unauthorized' do
      it 'return status 401 if there is no access token' do
        post '/api/v1/questions/1/answers', format: :json
        expect(response.status).to eq 401
      end

      it 'return status 401 if there is invalid access token' do
        post '/api/v1/questions/1/answers', format: :json, access_token: '12345'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      let!(:question) { create(:question) }
      let(:answer) { Answer.last }

      context 'with valid params' do

        let(:create_answer) { post "/api/v1/questions/#{ question.id }/answers", format: :json, access_token: access_token.token, question_id: question.id, answer: { body: '12345678910' } }

        it 'return status 201' do
          create_answer
          expect(response.status).to eq 201
        end

        pending 'Снова делать все проверки что вернулся ответ?'

        it 'save new answer in database' do
          expect { create_answer }.to change(Answer, :count).by(1)
        end

        it 'create answer with correct attributes' do
          create_answer
          expect(answer.body).to eq '12345678910'
          expect(answer.user_id).to eq user.id
          expect(answer.question_id).to eq question.id
        end
      end

      context 'with invalid params' do

        let(:create_answer) { post "/api/v1/questions/#{ question.id }/answers", format: :json, access_token: access_token.token, question_id: question.id, answer: { body: nil } }

        it 'return status 422' do
          create_answer
          expect(response.status).to eq 422
        end

        it 'doesnt save new answer in database' do
          expect { create_answer }.to_not change(Answer, :count)
        end

        it 'respond contain errors' do
          create_answer
          expect(response.body).to have_json_path('errors')
        end
      end
    end
  end
end
