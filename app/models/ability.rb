class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.super_admin?
      can :manage, :all
    elsif user.admin?
      can [:read, :create, :update], User
    else
      can :read, User
    end
  end
end
