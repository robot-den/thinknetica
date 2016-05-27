class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :get_commentable, only: :create

  def create
    @comment = @commentable.comments.build(comment_params.merge({user_id: current_user.id}))
    if @comment.save
      klass = @commentable.class.name
      question_id = (klass == 'Question' ? @commentable.id : @commentable.question_id)
      PrivatePub.publish_to "/questions/#{question_id}/comments", comment: @comment.to_json, commentable_type: klass, commentable_id: @commentable.id
      render nothing: true
    end
  end

  private

  def get_commentable
    # @commentable = resource.singularize.classify.constantize.find(id)
    @commentable = commentable_name.classify.constantize.find(params[:id])
  end

  def commentable_name
    params[:commentable]
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

end
