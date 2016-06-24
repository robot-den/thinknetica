class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      alias_action :vote_up, :vote_down, :vote_cancel, to: :vote

      can :read, Question
      can :create, [Question, Answer, Comment, Subscription]
      can [:update, :destroy], [Question, Answer], user: user
      can [:vote], [Question, Answer] { |votable| votable.user_id != user.id }
      can :set_as_best, Answer, question: { user: user }
      can :destroy, Attachment, attachable: { user: user }
      can :destroy, Subscription, user: user
    else
      can :read, Question
    end
  end
end
