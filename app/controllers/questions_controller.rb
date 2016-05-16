class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :get_question, only: [:show, :edit, :update, :destroy]
  before_action :get_votable_question, only: [:vote_up, :vote_down, :vote_cancel]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answer.attachments.build
    @answers = @question.answers.order("best DESC, created_at DESC")
  end

  def new
    @question = Question.new
    @question.attachments.build
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

  def vote_up
    @question.vote_up(current_user)
    render_voting
  end

  def vote_down
    @question.vote_down(current_user)
    render_voting
  end

  def vote_cancel
    @question.vote_cancel(current_user)
    render_voting
  end

  private

  def render_voting
    render json: { id: @question.id, rating: @question.rating }
  end

  def get_votable_question
    @question = Question.find(params[:votable_id])
  end

  def get_question
    @question = Question.find(params[:id])
  end

  def questions_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :id, :_destroy])
  end
end
