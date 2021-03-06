class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    alias_action :vote_up, :vote_down, to: :vote
    alias_action :update, :destroy, to: :manage_own

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def user_abilities
    guest_abilities

    can :create, [Question, Answer, Comment, Subscription]
    can :manage_own, [Question, Answer], user_id: user.id
    can :destroy, [Comment, Subscription], user_id: user.id

    can :vote, [Question, Answer] do |resource|
      resource.user_id != user.id
    end

    can :accept, Answer do |answer|
      answer.question.user_id == user.id
    end

    can :me, User
  end

  def admin_abilities
    can :manage, :all
  end
end
