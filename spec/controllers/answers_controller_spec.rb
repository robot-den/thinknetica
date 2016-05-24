require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  it_behaves_like 'voted'
  it_behaves_like 'commented'

  let(:question) { create(:question) }
  let(:answer) { create(:answer) }

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes via AJAX' do
      let(:create_answer) {  post :create, question_id: question.id, answer: attributes_for(:answer), format: :js }

      it "save new answer for question in database" do
        expect { create_answer }.to change(question.answers, :count).by(1)
      end

      it "render nothing" do
        create_answer
        expect(response.body).to eq ''
      end
    end

    context 'with invalid attributes via AJAX' do
      let(:create_invalid_answer) { post :create, question_id: question.id, answer: attributes_for(:invalid_answer), format: :js }

      it "does not save answer for question in database" do
        expect { create_invalid_answer }.to_not change(Answer, :count)
      end

      it "render create.js view" do
        create_invalid_answer
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    let(:valid_update) { patch :update, id: answer, answer: {body: "12345678910"}, format: :js }
    sign_in_user

    context 'by not the author of answer' do
      before { valid_update }

      it "does not change answer attributes" do
        answer.reload
        expect(answer.body).to_not eq '12345678910'
      end

      it "render update.js view" do
        expect(response).to render_template :update
      end
    end

    context 'with valid attributes by author' do
      let(:answer) { create(:answer, user_id: @user.id) }
      before { valid_update }

      it "assign requested answer to @answer" do
        expect(assigns(:answer)).to eq answer
      end

      it "change answer attributes" do
        answer.reload
        expect(answer.body).to eq "12345678910"
      end

      it "render update.js view" do
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes by author' do
      let(:answer) { create(:answer, user_id: @user.id) }
      before { patch :update, id: answer, answer: {body: nil}, format: :js }

      it "does not change answer attributes" do
        answer.reload
        expect(answer.body).to_not eq nil
      end

      it "render update.js view" do
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user
    let(:destroy_answer) { delete :destroy, id: answer, format: :js }

    context 'by the author of the answer' do
      let(:answer) { create(:answer, body: 'ExampleBody',question_id: question.id, user_id: @user.id) }

      it "delete answer from database" do
        answer
        expect { destroy_answer }.to change(Answer, :count).by(-1)
      end

      it "render update.js view" do
        destroy_answer
        expect(response).to render_template :destroy
      end
    end

    context "by not the author of the answer" do
      it "doesnt deletes answer from database" do
        answer
        expect { destroy_answer }.to_not change(Question, :count)
      end

      it "render update.js view" do
        destroy_answer
        expect(response).to render_template :destroy
      end
    end
  end

  describe 'PATCH #set_as_best' do
    sign_in_user
    let(:answer) { create(:answer, question: question) }
    let(:set_as_best) { patch :set_as_best, id: answer.id, format: :js }

    context 'by the author of the question' do
      let(:question) { create(:question, user_id: @user.id) }
      before { set_as_best }

      it 'assigns questions answers to @answers' do
        expect(assigns(:answers)).to eq question.answers
      end

      it 'change "best" attribute of answer' do
        answer.reload

        expect(answer.best?).to eq true
      end

      it 'render set_as_best.js view' do
        expect(response).to render_template :set_as_best
      end
    end

    context "by not the author of the question" do
      before { set_as_best }

      it 'doesnt change best_answer attribute of question' do
        answer.reload

        expect(answer.best?).to eq false
      end

      it 'render set_as_best.js view' do
        expect(response).to render_template :set_as_best
      end
    end
  end
end
