class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    user ? user_abilities : guest_abilities
  end

  def user_abilities
    alias_action :vote_up, :vote_down, :vote_cancel, to: :vote

    guest_abilities
    can :create, [Question, Answer, Comment, Subscription]
    can [:update, :destroy], [Question, Answer], user: user
    can [:vote], [Question, Answer] { |votable| votable.user_id != user.id }
    can :set_as_best, Answer, question: { user: user }
    can :destroy, Attachment, attachable: { user: user }
    can :destroy, Subscription, user: user
  end

  def guest_abilities
    can :read, Question
  end
end
