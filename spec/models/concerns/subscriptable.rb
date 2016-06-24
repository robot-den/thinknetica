require 'rails_helper'

shared_examples_for "subscriptable" do
  it { should have_many(:subscriptions).dependent(:destroy) }

  describe '#create_subscription' do
    let(:model) { described_class }
    let(:create_model) { create(model.to_s.underscore.to_sym) }
    let(:subscriptable) { model.last }

    it "creates new subscription after create subscriptable resource" do
      expect { create_model }.to change(Subscription, :count).by(1)
    end

    it "creates new subscription with correct attributes" do
      create_model
      expect(Subscription.last.user_id).to eq subscriptable.user_id
      expect(Subscription.last.subscriptable_id).to eq subscriptable.id
      expect(Subscription.last.subscriptable_type).to eq model.to_s
    end
  end
end
