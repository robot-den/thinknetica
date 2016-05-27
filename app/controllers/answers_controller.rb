class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  before_action :get_answer, only: [:update, :destroy, :set_as_best]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params.merge({user_id: current_user.id}))
    if @answer.save
      PrivatePub.publish_to "/questions/#{ @question.id }/answers", answer: @answer.to_json, attachments: answer_attachments(@answer), question_author_id: @question.user_id
      render nothing: true
    end
  end

  def update
    @answer.update(answer_params) if current_user.id == @answer.user_id
  end

  def destroy
    @answer.destroy if current_user.id == @answer.user_id
  end

  def set_as_best
    question = @answer.question
    if current_user.id == question.user_id
      @answer.set_as_best
      @answers = question.answers.order("best DESC, created_at DESC")
    end
  end

  private

  def answer_attachments(answer)
    arr = []
    answer.attachments.each_with_index do |attachment, i|
      arr[i] = {name: attachment.file.identifier, url: attachment.file.url, id: attachment.id}
    end
    arr.to_json
  end

  def get_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file, :id, :_destroy])
  end

end
