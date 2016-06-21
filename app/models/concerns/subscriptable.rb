module Subscriptable
  extend ActiveSupport::Concern
  included do
    has_many :subscriptions, as: :subscriptable, dependent: :destroy
  end
end
