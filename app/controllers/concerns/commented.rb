module Commented
  extend ActiveSupport::Concern

  included do
    before_action :get_commentable, only: :create_comment
  end

  def create_comment
    @comment =  @commentable.comments.build(comment_params.merge({user: current_user}))
    if @comment.save
      #Работает только для моделей связанных с question!
      question_id = (@commentable.class.name == 'Question' ? @commentable.id : @commentable.question.id)
      PrivatePub.publish_to "/questions/#{question_id}/comments", comment: @comment.to_json, commentable_type: @commentable.class.name, commentable_id: @commentable.id
      render nothing: true
    else
      render 'comments/create_comment'
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def get_commentable
    @commentable = model_klass.find(params[:id])
  end

  def model_klass
    controller_name.classify.constantize
  end
end
