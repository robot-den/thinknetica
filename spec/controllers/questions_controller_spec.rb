require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  it_behaves_like 'voted'
  it_behaves_like 'commented'

  let(:question) { create(:question) }

  describe  'GET #index' do
    let(:questions) { create_list(:question, 2) }
    before { get :index }

    it 'assigns all questions to @questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'render index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, id: question }

    it 'assigns requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns answers of question to @answers' do
      expect(assigns(:answers)).to eq question.answers
    end

    it 'build new attachment to @answer' do
      expect(assigns(:answer).attachments.first).to be_a_new(Attachment)
    end

    it 'assigns new answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'render show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    sign_in_user
    before { get :new }

    it 'assigns new question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'build new attachment to @question' do
      expect(assigns(:question).attachments.first).to be_a_new(Attachment)
    end

    it 'render new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    sign_in_user
    context 'with valid attributes' do
      let(:create_question) { post :create, question: attributes_for(:question) }

      it "save new question in database" do
        expect { create_question }.to change(Question, :count).by(1)
      end

      it "redirect to show view with notice" do
        create_question
        expect(response).to redirect_to question_path(assigns(:question))
        expect(flash[:notice]).to be_present
      end
    end

    context 'with invalid attributes' do
      let(:create_invalid_question) { post :create, question: attributes_for(:invalid_question) }

      it "does not save question in database" do
        expect { create_invalid_question }.to_not change(Question, :count)
      end

      it "render edit view" do
        create_invalid_question
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    let(:valid_update) { patch :update, id: question, question: {title: "12345678910", body: "12345678910"}, format: :js }
    sign_in_user

    context 'by not the author of question' do
      before { valid_update }

      it "does not change question attributes" do
        question.reload
        expect(question.title).to_not eq '12345678910'
        expect(question.body).to_not eq '12345678910'
      end

      it "render update.js view" do
        expect(response).to render_template :update
      end
    end

    context 'with valid attributes by author' do
      let(:question) { create(:question, user_id: @user.id) }
      before { valid_update }

      it "assign requested question to @question" do
        expect(assigns(:question)).to eq question
      end

      it "change question attributes" do
        question.reload
        expect(question.title).to eq "12345678910"
        expect(question.body).to eq "12345678910"
      end

      it "render update.js view" do
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes by author' do
      let(:question) { create(:question, user_id: @user.id) }
      before { patch :update, id: question, question: {body: "12345", title: nil}, format: :js }

      it "does not change question attributes" do
        question.reload
        expect(question.title).to eq "MyTitle123456789"
        expect(question.body).to eq "MyBody123456789"
      end

      it "render update.js view" do
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user
    let(:delete_question) { delete :destroy, id: question }

    context "by the author of the question" do
      let(:question) { create(:question, title: 'ExampleTitle', body: 'ExampleBody', user_id: @user.id) }

      it "deletes question from database" do
        question
        expect { delete_question }.to change(Question, :count).by(-1)
      end

      it "redirect to index view with notice" do
        delete_question
        expect(response).to redirect_to questions_url
        expect(flash[:notice]).to be_present
      end
    end

    context "by not the author of the question" do
      it "doesnt deletes question from database" do
        question
        expect { delete_question }.to_not change(Question, :count)
      end

      it "redirects to show view with notice" do
        delete_question
        expect(response).to redirect_to question_path(question)
        expect(flash[:notice]).to be_present
      end
    end
  end
end
