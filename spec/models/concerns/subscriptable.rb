require 'rails_helper'

shared_examples_for "subscriptable" do
  it { should have_many(:subscriptions).dependent(:destroy) }
end
