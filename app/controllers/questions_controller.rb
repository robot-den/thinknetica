class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  before_action :new_answer, only: :show
  after_action :publish_question, only: :create

  respond_to :js, only: :update

  def index
    respond_with(@questions = Question.all)
  end

  def show
    @answers = @question.answers.order('best DESC, created_at DESC')
    respond_with @question
  end

  def new
    respond_with(@question = Question.new)
  end

  def create
    respond_with(@question = Question.create(questions_params.merge(user_id: current_user.id)))
  end

  def update
    @question.update(questions_params) if current_user.id == @question.user_id
    respond_with @question
  end

  def destroy
    @question.destroy if current_user.id == @question.user_id
    respond_with @question
  end

  private

  def publish_question
    PrivatePub.publish_to '/questions', question: @question.to_json if @question.persisted?
  end

  def new_answer
    @answer = Answer.new
  end

  def load_question
    @question = Question.find(params[:id])
  end

  def questions_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :id, :_destroy])
  end
end
