module Votable
  extend ActiveSupport::Concern
  included do
    has_many :votes, as: :votable, dependent: :destroy

    def vote_up(user)
      self.votes.create(user: user, value: 1)
    end

    def vote_down(user)
      self.votes.create(user: user, value: -1)
    end

    def vote_cancel(user)
      if self.votes.exists?(user: user)
        self.votes.find_by(user: user).destroy
      end
    end


    def rating
      self.votes.sum(:value)
    end

  end
end
