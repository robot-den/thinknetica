class Api::V1::AnswersController < Api::V1::BaseController
  before_action :load_answer, only: :show
  
  def show
    respond_with @answer
  end

  private

  def load_answer
    @answer = Answer.find(params[:id])
  end
end
