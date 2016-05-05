class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :get_answer, only: [:edit, :update, :destroy]

  def new
    @answer = Answer.new
  end

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params.merge({user_id: current_user.id}))
    @answer.save
    respond_to do |format|
      format.html { redirect_to @question }
      format.js
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
    question = @answer.question_id
    if current_user.id == @answer.user_id
      @answer.destroy
      flash[:notice] = "Your answer deleted successfully"
    else
      flash[:notice] = "You can't delete that answer"
    end
    redirect_to question_path(question)
  end

  private

  def get_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end

end
