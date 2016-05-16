module Votable
  extend ActiveSupport::Concern
  included do
    has_many :votes, as: :votable, dependent: :destroy

    def vote_up(user)
      if self.user_id != user.id
        if Vote.exists?(user: user, votable_id: self.id, votable_type: self.class.name)
          Vote.find_by(user: user, votable_id: self.id, votable_type: self.class.name).update(value: 1)
        else
          Vote.create(user: user, votable_id: self.id, votable_type: self.class.name, value: 1)
        end
      end
    end

    def vote_down(user)
      if self.user_id != user.id
        if Vote.exists?(user: user, votable_id: self.id, votable_type: self.class.name)
          Vote.find_by(user: user, votable_id: self.id, votable_type: self.class.name).update(value: -1)
        else
          Vote.create(user: user, votable_id: self.id, votable_type: self.class.name, value: -1)
        end
      end
    end

    def vote_cancel(user)
      if Vote.exists?(user: user, votable_id: self.id, votable_type: self.class.name)
        Vote.find_by(user: user, votable_id: self.id, votable_type: self.class.name).update(value: 0)
      end
    end


    def rating
      Vote.where(votable_type: self.class.name, votable_id: self.id).sum(:value)
    end

  end
end
