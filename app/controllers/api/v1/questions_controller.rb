class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :load_question, only: [:show, :answers]

  def index
    respond_with Question.all, each_serializer: QuestionCollectionSerializer
  end

  def show
    respond_with @question
  end

  def answers
    respond_with @question.answers, each_serializer: AnswerCollectionSerializer
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end
end
