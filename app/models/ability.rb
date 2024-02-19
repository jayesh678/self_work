class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    # role_id 1=super_admin, role_id 2 = admin , role_id 3 = user
    if user.role_id == 1
      can :manage, :all
      cannot :destroy, User, role_id: 1 
    elsif user.role_id == 2
      can :manage, :all
      cannot :update, User, role_id: 1 
      cannot :destroy, User, role_id: 1 
    elsif user.role_id == 3
      can :read, [User, BusinessPartner, Expense]
      can :update, [User, BusinessPartner], id: user.id  
    else 
      can :read, :all
    end
  end
end
