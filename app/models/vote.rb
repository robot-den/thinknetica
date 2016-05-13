class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :value, inclusion: { in: -1..1 }

  def change_vote_value(param)
    current_value = self.value
    if param == '1' && current_value < 1
      self.update(value: current_value + 1)
      true
    elsif param == '-1' && current_value > -1
      self.update(value: current_value - 1)
      true
    else
      false
    end
  end
end
