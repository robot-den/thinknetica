class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  before_action :load_answer, only: [:update, :destroy, :set_as_best]
  before_action :load_question, only: :create
  after_action :publish_answer, only: :create

  respond_to :js

  authorize_resource

  def create
    respond_with(@answer = @question.answers.create(answer_params.merge(user_id: current_user.id)))
  end

  def update
    @answer.update(answer_params)
    respond_with @answer
  end

  def destroy
    @answer.destroy
    respond_with @answer
  end

  def set_as_best
    @answer.set_as_best
    @answers = @answer.question.answers.order('best DESC, created_at DESC') if @answer.best?
    respond_with @answer
  end

  private

  def publish_answer
    PrivatePub.publish_to "/questions/#{@question.id}/answers", answer: @answer.to_json, attachments: answer_attachments(@answer), question_author_id: @question.user_id if @answer.persisted?
  end

  def answer_attachments(answer)
    arr = []
    answer.attachments.each_with_index do |attachment, i|
      arr[i] = { name: attachment.file.identifier, url: attachment.file.url, id: attachment.id }
    end
    arr.to_json
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file, :id, :_destroy])
  end
end
