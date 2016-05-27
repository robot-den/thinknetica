require 'rails_helper'

RSpec.describe Question, type: :model do
  context 'validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :body }
    it { should validate_presence_of :user_id }
    it { should validate_length_of(:title).is_at_least(10) }
    it { should validate_length_of(:body).is_at_least(10) }
    it { should have_many(:answers).dependent(:destroy) }
    it { should have_many(:attachments).dependent(:destroy) }
    it { should have_many(:votes).dependent(:destroy) }
    it { should belong_to(:user) }
    it { should accept_nested_attributes_for(:attachments) }
  end

  it_behaves_like 'votable'
  it_behaves_like 'commentable'

end
