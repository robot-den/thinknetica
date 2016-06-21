require 'rails_helper'

RSpec.describe Subscription, type: :model do
  it { should belong_to :subscriptable }
  it { should belong_to :user }
  it { should validate_presence_of :user_id}
  it 'validate uniqueness of user with subcriptable' do
    subject.user = create(:user)
    should validate_uniqueness_of(:user_id).scoped_to(:subscriptable_id, :subscriptable_type)
  end
end
