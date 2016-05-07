class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :get_answer, only: [:update, :destroy]

  def new
    @answer = Answer.new
  end

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params.merge({user_id: current_user.id}))
    @answer.save
    # respond_to do |format|
    #   if @answer.save
    #     format.html { redirect_to @question }
    #     format.js
    #   else
    #     format.html { redirect_to @question }
    #     format.js { render :nothing => true }
    #   end
    # end
  end

  def update
    @answer.update(answer_params) if current_user.id == @answer.user_id
  end

  def destroy
    @answer.destroy if current_user.id == @answer.user_id
  end

  private

  def get_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end

end
