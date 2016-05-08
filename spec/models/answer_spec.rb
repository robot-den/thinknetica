require 'rails_helper'

RSpec.describe Answer, type: :model do
  context 'validations' do
    it { should validate_presence_of :body }
    it { should validate_presence_of :question_id }
    it { should validate_presence_of :user_id }
    # не работает с conditions
    # it { should validate_uniqueness_of(:best).scoped_to(:question_id).ignoring_case_sensitivity }
    it { should validate_length_of(:body).is_at_least(10) }
    it { should belong_to(:question) }
    it { should belong_to(:user) }
  end

  describe '#set_as_best method' do
    it 'set only one answer of question as best' do
      question = create(:question)
      answer1 = create(:answer, question: question)
      answer2 = create(:answer, question: question, best: true)
      answer3 = create(:answer, best: true)
      answer4 = create(:answer)

      answer1.set_as_best
      answer1.reload
      answer2.reload
      answer3.reload
      answer4.reload

      expect(answer1.best?).to eq true
      expect(answer2.best?).to eq false
      expect(answer3.best?).to eq true
      expect(answer4.best?).to eq false
    end
  end
end
