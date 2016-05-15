class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy
  has_many :votes, as: :votable, dependent: :destroy
  belongs_to :user

  validates :title, :body, :user_id, presence: true
  validates :title, :body, length: { minimum: 10 }

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

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
    Vote.where(votable_type: 'Question', votable_id: self.id).sum(:value)
  end
end
