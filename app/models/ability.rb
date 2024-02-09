class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
      if user.role_id == 1   #role_id =1 => super_admin 
        can :manage, :all
      elsif user.role_id == 2   
        can :manage, :all
      elsif user.role_id == 3
        can :read, User
      else 
        can :read, :all
      end
    end
end
