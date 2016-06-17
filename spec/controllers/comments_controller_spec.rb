require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

let(:commentable) { create(:question) }

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      let(:create_comment) { post :create, id: commentable.id, commentable: 'questions', comment: {body: 'valid comment'}, format: :js }

      it 'create new comment for commentable' do
        expect { create_comment }.to change(commentable.comments, :count).by(1)
      end

      it 'sends message to channel after create comment' do
        expect(PrivatePub).to receive(:publish_to).with("/questions/#{ commentable.id }/comments", anything)
        create_comment
      end

      it 'render nothing' do
        create_comment
        expect(response.body).to eq ''
      end
    end

    context 'with invalid attributes' do
      let(:create_invalid_comment) { post :create, id: commentable.id, commentable: 'questions', comment: {body: nil}, format: :js }

      it 'doesnt create new comment for commentable' do
        expect { create_invalid_comment }.to_not change(Comment, :count)
      end

      it 'does not sends message to channel' do
        expect(PrivatePub).to_not receive(:publish_to)
        create_invalid_comment
      end

      it 'render error view' do
        create_invalid_comment
        expect(response).to render_template :create
      end
    end
  end
end
