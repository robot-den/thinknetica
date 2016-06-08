class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable, only: :create
  after_action :publish_comment, only: :create

  respond_to :js

  def create
    authorize! :create, Comment
    respond_with(@comment = @commentable.comments.create(comment_params.merge(user_id: current_user.id)))
  end

  private

  # publishing comments works only for questions and related resourses
  def publish_comment
    if @comment.persisted?
      klass = @commentable.class.name
      question_id = (klass == 'Question' ? @commentable.id : @commentable.question_id)
      PrivatePub.publish_to "/questions/#{question_id}/comments", comment: @comment.to_json, commentable_type: klass, commentable_id: @commentable.id
    end
  end

  def load_commentable
    @commentable = commentable_name.classify.constantize.find(params[:id])
  end

  def commentable_name
    params[:commentable]
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
