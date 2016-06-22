require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:subscriptable) { create(:question) }

  describe 'POST #create' do
    sign_in_user

    let(:create_subscription) { post :create, id: subscriptable.id, subscriptable: 'questions', format: :js }

    context 'new subscribtion' do
      it 'create new subscription for subscriptable' do
        expect { create_subscription }.to change(subscriptable.subscriptions, :count).by(1)
      end

      it 'render create.js view' do
        create_subscription
        expect(response).to render_template :create
      end
    end

    context 'try subscribe second time' do
      before { create_subscription }

      it 'doesnt create new subscription for subscriptable' do
        expect { create_subscription }.to_not change(Subscription, :count)
      end

      it 'render create.js view' do
        create_subscription
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user
    let(:destroy_subscription) { delete :destroy, id: subscriptable.id, subscriptable: 'questions', format: :js }
    let!(:subscriptions) { create_list(:subscription, 2, subscriptable: subscriptable) }

    context 'if user subscription exists' do
      before { create(:subscription, subscriptable: subscriptable, user: @user) }

      it "delete user subscription from database" do
        expect { destroy_subscription }.to change(Subscription, :count).by(-1)
      end

      it "render destroy.js view" do
        destroy_subscription
        expect(response).to render_template :destroy
      end
    end

    context "if user subscription does not exists" do
      it "does not deletes any subscriptions from database" do
        expect { destroy_subscription }.to_not change(Subscription, :count)
      end

      it "redirect to root path (cancan)" do
        destroy_subscription
        expect(response).to redirect_to root_path
      end
    end
  end
end
