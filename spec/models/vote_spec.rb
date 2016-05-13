require 'rails_helper'

RSpec.describe Vote, type: :model do
  context 'validations' do
    it { should belong_to(:user) }
    it { should belong_to(:votable) }
    it { should validate_inclusion_of(:value).in_range(-1..1) }
  end

  describe '#change_vote_value' do
    let(:user) { create(:user) }
    it "change value only if params eq '1' or '-1'" do
      vote = create(:vote)

      vote.change_vote_value('1')
      expect(vote.value).to eq 1

      vote.change_vote_value('-1')
      expect(vote.value).to eq 0
    end

    it "doesn't increase value if value will out of range -1..1 after that" do
      vote = create(:vote, :up)

      vote.change_vote_value('1')
      expect(vote.value).to eq 1

      vote = create(:vote, :down)

      vote.change_vote_value('-1')
      expect(vote.value).to eq -1
    end
  end
end
