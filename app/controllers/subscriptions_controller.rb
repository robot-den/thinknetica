class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_subscriptable, only: [:create, :destroy]
  before_action :load_subscription, only: :destroy

  respond_to :js

  def create
    respond_with(@subscription = @subscriptable.subscriptions.create!(user: current_user))
  end

  def destroy
    @subscription.destroy if @subscription
    respond_with @subscription
  end

  private

  def load_subscription
    @subscription = @subscriptable.subscriptions.find_by(user: current_user)
  end

  def load_subscriptable
    @subscriptable = subscriptable_name.classify.constantize.find(params[:id])
  end

  def subscriptable_name
    params[:subscriptable]
  end
end
