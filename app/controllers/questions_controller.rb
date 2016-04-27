class QuestionsController < ApplicationController
  before_action :get_question, only: [:show, :edit, :update, :destroy]

  def index
    @questions = Question.all
  end

  def show
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(questions_params)
    if @question.save
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
    if @question.update_attributes(questions_params)
      respond_to do |format|
        format.html { redirect_to @question }
      end
    else
      respond_to do |format|
        format.html { render :edit }
      end
    end
  end

  def destroy
    @question.destroy
    redirect_to questions_url
  end

  private

  def get_question
    @question = Question.find(params[:id])
  end

  def questions_params
    params.require(:question).permit(:title, :body)
  end
end
