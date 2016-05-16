module Voted
  extend ActiveSupport::Concern

  included do
    before_action :get_votable, only: [:vote_up, :vote_down, :vote_cancel]
  end

  def vote_up
    @votable.vote_up(current_user)
    render_voting
  end

  def vote_down
    @votable.vote_down(current_user)
    render_voting
  end

  def vote_cancel
    @votable.vote_cancel(current_user)
    render_voting
  end

  private

  def render_voting
    render json: { id: @votable.id, rating: @votable.rating }
  end

  def get_votable
    @votable = model_klass.find(params[:votable_id])
  end

  def model_klass
    controller_name.classify.constantize
  end

end
