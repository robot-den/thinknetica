class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :get_answer, only: [:edit, :update, :destroy]
  before_action :get_question, only: [:create, :destroy]

  def new
    @answer = Answer.new
  end

  def create
    @answer = @question.answers.new(answer_params.merge({user_id: current_user.id}))
    if @answer.save
      redirect_to @question
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @answer.update(answer_params)
      redirect_to question_url(@answer.question_id)
    else
      render :edit
    end
  end

  def destroy
    @answer.destroy
    redirect_to @question
  end

  private

  def get_question
    @question = Question.find(params[:question_id])
  end

  def get_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end

end
