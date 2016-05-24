require 'rails_helper'

shared_examples 'commented' do
  # может есть способ получше чтобы получать символ модели
  model = controller_class.controller_path.singularize
  let(:commentable) { create(model.to_sym) }

  describe 'POST #create_comment' do
    sign_in_user

    context 'with valid attributes' do
      let(:create_comment) { post :create_comment, id: commentable, comment: {body: 'valid comment'}, format: :js }

      it 'create new comment for commentable' do
        expect { create_comment }.to change(commentable.comments, :count).by(1)
      end

      it 'render nothing' do
        create_comment
        expect(response.body).to eq ''
      end
    end

    context 'with invalid attributes' do
      let(:create_invalid_comment) { post :create_comment, id: commentable, comment: {body: nil}, format: :js }

      it 'doesnt create new comment for commentable' do
        expect { create_invalid_comment }.to_not change(Comment, :count)
      end

      it 'render error view' do
        create_invalid_comment
        expect(response).to render_template :create_comment
      end
    end
  end
end
