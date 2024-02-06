class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
      if user.role_id == 1
        can :manage, :all
      elsif user.role_id == 2
        can :manage, :all
      elsif user.role_id == 3
        can :read, BusinessPartner
      else 
        can :read, :all
      end
    end
end
