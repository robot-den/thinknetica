module Subscriptable
  extend ActiveSupport::Concern
  included do
    has_many :subscriptions, as: :subscriptable, dependent: :destroy

    after_create :create_subscription

    private

    def create_subscription
      Subscription.create(user: self.user, subscriptable: self)
    end
  end
end
