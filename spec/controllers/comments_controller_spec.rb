require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

  # пытался оставить этот спек в consern'ах, использовал :type => :request но с ним не могу залогинить пользователя
  # и если не указывать commentable: 'questions' в запросе, то в контроллере ошибка, наверное здесь мимо роутов обращение идет, и не подсовывается этот параметр в params
  let(:commentable) { create(:question) }

  describe 'POST #create_comment' do
    sign_in_user

    context 'with valid attributes' do
      let(:create_comment) { post :create, id: commentable.id, commentable: 'questions', comment: {body: 'valid comment'}, format: :js }

      it 'create new comment for commentable' do
        expect { create_comment }.to change(commentable.comments, :count).by(1)
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

      it 'render error view' do
        create_invalid_comment
        expect(response).to render_template :create
      end
    end
  end
end
