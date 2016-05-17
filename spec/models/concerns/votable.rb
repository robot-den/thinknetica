require 'rails_helper'

shared_examples_for "votable" do
  let(:model) { described_class }
  let(:votable) { create(model.to_s.underscore.to_sym) }
  let(:user) { create(:user) }

  describe 'method #rating' do
    it 'return sum of values all votes for current question' do
      create_list(:vote, 3, :up, votable: votable)
      expect(votable.rating).to eq 3
    end
  end

  describe 'method #vote_up' do
    it 'create new vote with value equal 1' do
      expect { votable.vote_up(user) }.to change(votable.votes, :count).by(1)
      expect(votable.votes.first.value).to eq 1
    end
  end

  describe 'method #vote_down' do
    it 'create new vote with value equal -1' do
      expect { votable.vote_down(user) }.to change(votable.votes, :count).by(1)
      expect(votable.votes.first.value).to eq -1
    end
  end

  describe 'method #vote_cancel' do
    let!(:vote) { create(:vote, votable: votable, user: user) }

    it 'delete vote from database' do
      votable.vote_cancel(user)
      expect(votable.votes.count).to eq 0
    end
  end
end
