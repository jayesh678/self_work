class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.role.role_name == "super_admin"
      can :manage, :all
      cannot [:destroy, :update], User, role: { role_name: "super_admin" }
    elsif user.role.role_name == "admin"
      can :manage, [User, BusinessPartner]
      can [:read, :update, :destroy], Expense, user: { role: { role_name: ["admin", "user"] } }
      can :create, Expense
      cannot [:destroy, :update], User, role: { role_name: "super_admin" }
    elsif user.role.role_name == "user"
      can :read, Expense
      can [:create, :update, :destroy], Expense, user_id: user.id
    else
      can :read, [User, Expense, BusinessPartner]
    end
  end
end
