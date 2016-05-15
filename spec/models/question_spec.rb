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

  describe 'method #rating' do
    let(:question) { create(:question) }
    let!(:vote) { create_list(:vote, 3, :up, votable: question) }

    it 'return sum of values all votes for current question' do
      expect(question.rating).to eq 3
    end
  end

  describe 'method #vote_up' do
    let(:user) { create(:user) }
    let(:vote) { create(:vote, votable: question, user: user) }

    context 'current user is not author of question' do
      let(:question) { create(:question) }

      it 'create new vote if it doesnt exists' do
        expect { question.vote_up(user) }.to change(question.votes, :count).by(1)
      end

      it 'sets value of vote equal 1' do
        vote
        question.vote_up(user)
        vote.reload
        expect(vote.value).to eq 1
      end
    end

    context 'current user is author of question' do
      let(:question) { create(:question, user: user) }

      it 'doesnt create new vote' do
        expect { question.vote_up(user) }.to_not change(Vote, :count)
      end

      it 'doesnt change value of vote' do
        vote
        question.vote_up(user)
        vote.reload
        expect(vote.value).to eq 0
      end
    end
  end

  describe 'method #vote_down' do
    let(:user) { create(:user) }
    let(:vote) { create(:vote, votable: question, user: user) }

    context 'current user is not author of question' do
      let(:question) { create(:question) }

      it 'create new vote if it doesnt exists' do
        expect { question.vote_down(user) }.to change(question.votes, :count).by(1)
      end

      it 'sets value of vote equal -1' do
        vote
        question.vote_down(user)
        vote.reload
        expect(vote.value).to eq -1
      end
    end

    context 'current user is author of question' do
      let(:question) { create(:question, user: user) }

      it 'doesnt create new vote' do
        expect { question.vote_down(user) }.to_not change(Vote, :count)
      end

      it 'doesnt change value of vote' do
        vote
        question.vote_down(user)
        vote.reload
        expect(vote.value).to eq 0
      end
    end
  end

  describe 'method #vote_cancel' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }

    it 'sets value of vote equal 0' do
      vote = create(:vote, :up, votable: question, user: user)
      question.vote_cancel(user)
      vote.reload
      expect(vote.value).to eq 0
    end
  end


end
