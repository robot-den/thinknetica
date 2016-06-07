class Ability
  include CanCan::Ability

  def initialize(user)
    if user

      # Question
      can :read, Question
      can :create, Question
      can :update, Question, user: user
      can :destroy, Question, user: user
      can :vote_up, Question
      can :vote_down, Question
      can :vote_cancel, Question
      cannot :vote_up, Question, user: user
      cannot :vote_down, Question, user: user
      cannot :vote_cancel, Question, user: user

      # Answer
      can :create, Answer
      can :update, Answer, user: user
      can :destroy, Answer, user: user
      can :set_as_best, Answer, question: { user: user }

      can :vote_up, Answer
      can :vote_down, Answer
      can :vote_cancel, Answer
      cannot :vote_up, Answer, user: user
      cannot :vote_down, Answer, user: user
      cannot :vote_cancel, Answer, user: user


    else
      can :read, Question
    end
  end
end
