class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :get_question, only: [:show, :edit, :update, :destroy]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(questions_params.merge({user_id: current_user.id}))
    if @question.save
      flash[:notice] = "Your question created successfully"
      redirect_to @question
    else
      render :new
    end
  end

  def update
    @question.update(questions_params) if current_user.id == @question.user_id
  end

  def destroy
    if current_user.id == @question.user_id
      @question.destroy
      flash[:notice] = "Your question deleted successfully"
      redirect_to questions_url
    else
      flash[:notice] = "You can't delete that question"
      redirect_to question_path(@question)
    end
  end

  private

  def get_question
    @question = Question.find(params[:id])
  end

  def questions_params
    params.require(:question).permit(:title, :body)
  end
end
