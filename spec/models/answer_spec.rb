require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of :body }
  it { should validate_presence_of :question_id }
  it { should validate_presence_of :user_id }
  it { should validate_length_of(:body).is_at_least(10) }
  it { should belong_to(:question) }
  it { should belong_to(:user) }

  describe '#set_as_best method' do
    it 'set only one answer of question as best' do
      question = create(:question)
      answer1 = create(:answer, question: question)
      answer2 = create(:answer, question: question, best: true)

      Answer.set_as_best(answer1)
      answer1.reload
      answer2.reload

      expect(answer1.best?).to eq true
      expect(answer2.best?).to eq false
    end
  end
end
