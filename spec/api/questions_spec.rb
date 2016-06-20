require 'rails_helper'

describe 'Questions API' do
  let(:user) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: user.id) }

  describe 'GET #index' do
    it_behaves_like 'API authenticable'

    context 'authorized' do
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

    def do_request(options = {})
      get '/api/v1/questions', { format: :json }.merge(options)
    end
  end

  describe 'GET #show' do
    it_behaves_like 'API authenticable'

    context 'authorized' do
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

    def do_request(options = {})
      get '/api/v1/questions/1', { format: :json }.merge(options)
    end
  end

  describe 'GET #answers' do
    it_behaves_like 'API authenticable'

    context 'authorized' do
      let!(:question) { create(:question) }
      let!(:answers) { create_list(:answer, 2, question: question) }
      let(:answer) { answers.first }

      before { get "/api/v1/questions/#{ question.id }/answers", format: :json, access_token: access_token.token }

      it 'return status 200' do
        expect(response.status).to eq 200
      end

      it 'respond contains all answers of question' do
        expect(response.body).to have_json_size(2).at_path('answers')
      end

      %w{body id created_at updated_at}.each do |key|
        it "json for each answer from list contains #{ key }" do
            expect(response.body).to be_json_eql(answer.send(key.to_sym).to_json).at_path("answers/0/#{ key }")
        end
      end
    end

    def do_request(options = {})
      get '/api/v1/questions/1/answers', { format: :json }.merge(options)
    end
  end

  describe 'POST #create' do
    it_behaves_like 'API authenticable'

    context 'authorized' do
      context 'with valid params' do
        let(:create_question) { post "/api/v1/questions", format: :json, access_token: access_token.token, question: { title: '12345678910', body: '12345678910' } }
        let(:question) { Question.last }

        it 'save new question in database', :skip_before do
          expect { create_question }.to change(Question, :count).by(1)
        end

        it 'return status 201' do
          create_question
          expect(response.status).to eq 201
        end

        %w{title body id created_at updated_at}.each do |key|
          it "response with new question contains #{ key }" do
            create_question
            expect(response.body).to be_json_eql(question.send(key.to_sym).to_json).at_path("question/#{ key }")
          end
        end

        it 'question contain no comments' do
          create_question
          expect(response.body).to have_json_size(0).at_path('question/comments')
        end

        it 'question contain no attachments' do
          create_question
          expect(response.body).to have_json_size(0).at_path('question/attachments')
        end

        it 'create question with correct attributes' do
          create_question
          expect(question.body).to eq '12345678910'
          expect(question.title).to eq '12345678910'
          expect(question.user_id).to eq user.id
        end
      end

      context 'with invalid params' do

        let(:create_question) { post "/api/v1/questions", format: :json, access_token: access_token.token, question: { title: nil, body: nil } }

        it 'return status 422' do
          create_question
          expect(response.status).to eq 422
        end

        it 'doesnt save new question in database' do
          expect { create_question }.to_not change(Question, :count)
        end

        it 'respond contain errors' do
          create_question
          expect(response.body).to have_json_path('errors')
        end
      end
    end

    def do_request(options = {})
      post '/api/v1/questions', { format: :json }.merge(options)
    end
  end
end
