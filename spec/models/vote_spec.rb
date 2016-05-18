require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to :votable }
  it { should belong_to :user }
  it { should validate_presence_of(:value) }
  it { should validate_presence_of(:user_id) }
  it { should validate_inclusion_of(:value).in_range(-1..1) }
  it do
    subject.user = create(:user)
    should validate_uniqueness_of(:user_id).scoped_to(:votable_id, :votable_type)
  end
end
