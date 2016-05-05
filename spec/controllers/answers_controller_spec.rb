require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }

  describe 'GET #new' do
    sign_in_user
    before { get :new, question_id: question }

    it 'assigns new answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'render new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    sign_in_user
    context 'with valid attributes' do
      let(:create_answer) {  post :create, question_id: question.id, answer: attributes_for(:answer) }

      it "save new answer for question in database" do
        expect { create_answer }.to change(question.answers, :count).by(1)
      end

      it "redirect to question" do
        create_answer
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'with invalid attributes' do
      let(:create_invalid_answer) { post :create, question_id: question.id, answer: attributes_for(:invalid_answer) }

      it "does not save answer for question in database" do
        expect { create_invalid_answer }.to_not change(Answer, :count)
      end

      it "redirect to new view" do
        create_invalid_answer
        expect(response).to render_template :new
      end
    end
  end

  describe 'GET #edit' do
    sign_in_user
    before { get :edit, id: answer}

    it 'assigns requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'render edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'PATCH #update' do
    sign_in_user
    context 'with valid attributes' do
      it "assign requested answer to @answer" do
        patch :update, id: answer, answer: attributes_for(:answer)
        expect(assigns(:answer)).to eq answer
      end

      it "change answer attributes" do
        patch :update, id: answer, answer: {body: "12345678910"}
        answer.reload
        expect(answer.body).to eq "12345678910"
      end

      it "redirect to question show view" do
        patch :update, id: answer, answer: attributes_for(:answer)
        expect(response).to redirect_to question_url(answer.question_id)
      end

      context 'with invalid attributes' do
        it "does not change answer attributes" do
          patch :update, id: answer, answer: {body: nil}
          answer.reload
          expect(answer.body).to eq "MyText123456789"
        end

        it "render edit view" do
          patch :update, id: answer, answer: {body: nil}
          expect(response).to render_template :edit
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    context 'by the author of the answer' do
      let(:answer) { Answer.create!(body: 'ExampleBody',question_id: question.id, user_id: @user.id) }

      it "delete answer from database" do
        answer
        expect { delete :destroy, id: answer }.to change(Answer, :count).by(-1)
      end

      it "redirect to question show view with notice" do
        delete :destroy, id: answer
        expect(response).to redirect_to question_url(answer.question_id)
        expect(flash[:notice]).to be_present
      end
    end

    context "by not the author of the answer" do
      it "doesnt deletes answer from database" do
        answer
        expect { delete :destroy, id: answer }.to_not change(Question, :count)
      end

      it "redirects to question show view with notice" do
        delete :destroy, id: answer
        expect(response).to redirect_to question_path(answer.question_id)
        expect(flash[:notice]).to be_present
      end
    end
  end
end
