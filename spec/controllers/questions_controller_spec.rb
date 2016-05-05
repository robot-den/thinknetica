require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
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

      it "redirect to edit view" do
        create_invalid_question
        expect(response).to render_template :new
      end
    end
  end

  describe 'GET #edit' do
    sign_in_user
    before { get :edit, id: question }

    it 'assigns requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'render edit view' do
      expect(response).to render_template(:edit)
    end
  end

  describe 'PATCH #update' do
    sign_in_user
    context 'with valid attributes' do
      let(:update_question) { patch :update, id: question, question: attributes_for(:question) }

      it "assign requested question to @question" do
        update_question
        expect(assigns(:question)).to eq question
      end

      it "change question attributes" do
        patch :update, id: question, question: {body: "12345678910", title: "12345678910"}
        question.reload
        expect(question.title).to eq "12345678910"
        expect(question.body).to eq "12345678910"
      end

      it "redirect to show view" do
        update_question
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      it "does not change question attributes" do
        patch :update, id: question, question: {body: "12345", title: nil}
        question.reload
        expect(question.title).to eq "MyTitle123456789"
        expect(question.body).to eq "MyBody123456789"
      end

      it "render edit view" do
        patch :update, id: question, question: {body: "12345", title: nil}
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    context "by the author of the question" do
      let(:question) { Question.create!(title: 'ExampleTitle', body: 'ExampleBody', user_id: @user.id) }

      it "deletes question from database" do
        question
        expect { delete :destroy, id: question }.to change(Question, :count).by(-1)
      end

      it "redirect to index view with notice" do
        delete :destroy, id: question
        expect(response).to redirect_to questions_url
        expect(flash[:notice]).to be_present
      end
    end

    context "by not the author of the question" do
      it "doesnt deletes question from database" do
        question
        expect { delete :destroy, id: question }.to_not change(Question, :count)
      end

      it "redirects to show view with notice" do
        delete :destroy, id: question
        expect(response).to redirect_to question_path(question)
        expect(flash[:notice]).to be_present
      end
    end
  end
end