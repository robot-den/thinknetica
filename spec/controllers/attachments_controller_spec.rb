require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do

  describe 'DELETE #destroy' do
    let(:attachment) { question.attachments.first }
    let(:destroy_attachment) { delete :destroy, id: attachment, format: :js }
    sign_in_user

    context 'by the author of question' do
      let(:question) { create(:question, :with_attachment, user: @user) }

      it 'delete attachment file from database' do
        attachment
        expect { destroy_attachment }.to change(question.attachments, :count).by(-1)
      end

      it 'render destroy.js view' do
        destroy_attachment
        expect(response).to render_template :destroy
      end
    end

    context 'by not the author of question' do
      let(:question) { create(:question, :with_attachment) }

      it 'doesnt deletes attachment from database' do
        attachment
        expect { destroy_attachment }.to_not change(Attachment, :count)
      end

      it 'redirect to root_url' do
        destroy_attachment
        expect(response).to redirect_to root_url
      end
    end
  end
end
