class VotesController < ApplicationController

  # Он прекрасен
  def vote
    votable = (params[:votable_type]).constantize.find(params[:votable_id])
    
    if votable.user_id != current_user.id
      if Vote.exists?(user: current_user, votable: votable)
        vote = Vote.where(user: current_user, votable: votable).first
      else
        vote = votable.votes.create(value: 0, user: current_user)
      end

      if vote.change_vote_value(params[:value])
        render json: vote
      else
        render nothing: true, status: 403
      end
    else
      render nothing: true, status: 403
    end
  end
end
