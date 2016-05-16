require 'rails_helper'

shared_examples_for "votable" do
  let(:model) { described_class }
  let(:votable) { create(model.to_s.underscore.to_sym) }
  let(:user) { create(:user) }
  let(:vote) { create(:vote, votable: votable, user: user) }

  describe 'method #rating' do
    it 'return sum of values all votes for current question' do
      create_list(:vote, 3, :up, votable: votable)
      expect(votable.rating).to eq 3
    end
  end

  describe 'method #vote_up' do
    context 'current user is not author of question' do
      it 'create new vote if it doesnt exists' do
        expect { votable.vote_up(user) }.to change(votable.votes, :count).by(1)
      end

      it 'sets value of vote equal 1' do
        vote
        votable.vote_up(user)
        vote.reload
        expect(vote.value).to eq 1
      end
    end

    context 'current user is author of question' do
      let(:votable) { create(model.to_s.underscore.to_sym, user: user) }

      it 'doesnt create new vote' do
        expect { votable.vote_up(user) }.to_not change(Vote, :count)
      end

      it 'doesnt change value of vote' do
        vote
        votable.vote_up(user)
        vote.reload
        expect(vote.value).to eq 0
      end
    end
  end

  describe 'method #vote_down' do
    context 'current user is not author of question' do
      it 'create new vote if it doesnt exists' do
        expect { votable.vote_down(user) }.to change(votable.votes, :count).by(1)
      end

      it 'sets value of vote equal -1' do
        vote
        votable.vote_down(user)
        vote.reload
        expect(vote.value).to eq -1
      end
    end

    context 'current user is author of question' do
      let(:votable) { create(model.to_s.underscore.to_sym, user: user) }

      it 'doesnt create new vote' do
        expect { votable.vote_down(user) }.to_not change(Vote, :count)
      end

      it 'doesnt change value of vote' do
        vote
        votable.vote_down(user)
        vote.reload
        expect(vote.value).to eq 0
      end
    end
  end

  describe 'method #vote_cancel' do
    it 'sets value of vote equal 0' do
      vote = create(:vote, :up, votable: votable, user: user)
      votable.vote_cancel(user)
      vote.reload
      expect(vote.value).to eq 0
    end
  end
end
