module Votable
  extend ActiveSupport::Concern
  included do
    has_many :votes, as: :votable, dependent: :destroy

    def current_rating
      self.votes.sum(:value)
    end
  end
end
