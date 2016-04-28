class AnswersController < ApplicationController
  before_action :get_answer, only: [:edit, :update, :destroy]
  before_action :get_question, only: [:create, :destroy]

  def new
    @answer = Answer.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    if @answer.save
      respond_to do |format|
        format.html { redirect_to @question }
      end
    else
      respond_to do |format|
        format.html { render :new }
      end
    end
  end

  def edit
  end

  def update
    if @answer.update_attributes(answer_params)
      respond_to do |format|
        format.html { redirect_to question_url(@answer.question_id) }
      end
    else
      respond_to do |format|
        format.html { render :edit }
      end
    end
  end

  def destroy
    @answer.destroy
    respond_to do |format|
      format.html { redirect_to @question }
    end
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
