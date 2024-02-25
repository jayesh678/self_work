class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.role.role_name == "super_admin"
      can :manage, :all
      cannot :destroy, User, role: { role_name: "super_admin" }
    elsif user.role.role_name == "admin"
      can :manage, [User, BusinessPartner, Expense]
      cannot :update, User, role: { role_name: "super_admin" }
      cannot :destroy, User, role: { role_name: "super_admin" }
    elsif user.role.role_name == "user"
      can :read, Expense, user_id: user.id
      cannot :read, BusinessPartner
    else
      can :read, [User, Expense]
    end
  end
end
