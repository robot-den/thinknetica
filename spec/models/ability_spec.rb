require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should_not be_able_to :manage, :all }
  end

  describe 'user' do
    let(:user) { create :user }
    let(:question) { create :question }
    let(:user_question) { create :question, user: user }
    let(:answer) { create :answer }
    let(:user_answer) { create :answer, user: user }
    let(:answer_of_users_question) { create :answer, question: user_question }


    it { should_not be_able_to :manage, :all }

    context 'question' do
      it { should be_able_to :read, Question }
      it { should be_able_to :create, Question }
      it { should be_able_to :update, user_question, user: user }
      it { should be_able_to :destroy, user_question, user: user }
      it { should be_able_to :vote_up, question, user: user }
      it { should be_able_to :vote_down, question, user: user }
      it { should be_able_to :vote_cancel, question, user: user }

      it { should_not be_able_to :vote_up, user_question, user: user }
      it { should_not be_able_to :vote_down, user_question, user: user }
      it { should_not be_able_to :vote_cancel, user_question, user: user }
      it { should_not be_able_to :update, question, user: user }
      it { should_not be_able_to :destroy, question, user: user }
    end

    context 'answer' do
      it { should be_able_to :create, Answer }
      it { should be_able_to :update, user_answer, user: user }
      it { should be_able_to :destroy, user_answer, user: user }
      it { should be_able_to :set_as_best, answer_of_users_question, user: user }
      it { should be_able_to :vote_up, answer, user: user }
      it { should be_able_to :vote_down, answer, user: user }
      it { should be_able_to :vote_cancel, answer, user: user }

      it { should_not be_able_to :vote_up, user_answer, user: user }
      it { should_not be_able_to :vote_down, user_answer, user: user }
      it { should_not be_able_to :vote_cancel, user_answer, user: user }
      it { should_not be_able_to :update, answer, user: user }
      it { should_not be_able_to :destroy, answer, user: user }
      it { should_not be_able_to :manage, :all }
      it { should_not be_able_to :set_as_best, answer }
    end

    context 'attachments' do
      let(:attachment) { create(:attachment, attachable: answer) }
      let(:user_attachment) { create(:attachment, attachable: user_answer) }

      it { should be_able_to :destroy, user_attachment, attachable: { user: user }  }
      it { should_not be_able_to :destroy, attachment, attachable: { user: user }  }
    end
  end
end
