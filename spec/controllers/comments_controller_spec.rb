require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

  # пытался оставить этот спек в consern'ах, но запросы не проходят (:type => :request не очень помогло)
  let(:commentable) { create(:question) }

  describe 'POST #create_comment' do
    sign_in_user

    context 'with valid attributes' do
      let(:create_comment) { post :create, question_id: commentable.id, comment: {body: 'valid comment'}, format: :js }

      it 'create new comment for commentable' do
        expect { create_comment }.to change(commentable.comments, :count).by(1)
      end

      it 'render nothing' do
        create_comment
        expect(response.body).to eq ''
      end
    end

    context 'with invalid attributes' do
      let(:create_invalid_comment) { post :create, question_id: commentable.id, comment: {body: nil}, format: :js }

      it 'doesnt create new comment for commentable' do
        expect { create_invalid_comment }.to_not change(Comment, :count)
      end

      it 'render error view' do
        create_invalid_comment
        expect(response).to render_template :create
      end
    end
  end
end
