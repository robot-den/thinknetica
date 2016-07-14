require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should belong_to(:commentable).touch(true) }
  it { should belong_to :user }
  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:user_id) }
  it { should validate_length_of(:body).is_at_least(5) }
end
