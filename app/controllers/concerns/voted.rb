module Voted
  extend ActiveSupport::Concern

  included do
    before_action :get_votable, only: [:vote_up, :vote_down, :vote_cancel]
    before_action :check_author, only: [:vote_up, :vote_down]
  end

  def vote_up
    @votable.vote_up(current_user)
    render_voting(true)
  end

  def vote_down
    @votable.vote_down(current_user)
    render_voting(true)
  end

  def vote_cancel
    @votable.vote_cancel(current_user)
    render_voting(false)
  end

  private

  def check_author
    render nothing: true, status: 422 if @votable.user_id == current_user.id || @votable.votes.exists?(user: current_user)
  end

  def render_voting(status)
    render json: { id: @votable.id, rating: @votable.rating, voted: status  }
  end

  def get_votable
    @votable = model_klass.find(params[:id])
  end

  def model_klass
    controller_name.classify.constantize
  end

end
