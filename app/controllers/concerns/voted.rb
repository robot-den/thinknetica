module Voted
  extend ActiveSupport::Concern

  included do
    before_action :get_votable, only: [:vote_up, :vote_down, :vote_cancel]
    before_action :check_exists, only: [:vote_up, :vote_down]
  end

  def vote_up
    authorize! :vote_up, @votable
    @votable.vote_up(current_user)
    render_voting(true)
  end

  def vote_down
    authorize! :vote_down, @votable
    @votable.vote_down(current_user)
    render_voting(true)
  end

  def vote_cancel
    authorize! :vote_cancel, @votable
    @votable.vote_cancel(current_user)
    render_voting(false)
  end

  private

  def check_exists
    render nothing: true, status: 403 if @votable.votes.exists?(user: current_user)
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
