class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    
    if user.role_id == 1 || user.role_id == 2
      can :manage, :all
    elsif user.role_id == 3
      can :read, [User, BusinessPartner, Expense]
      can :update, [User, BusinessPartner], id: user.id  # Allow the user to update their own profile and business partners
    else 
      can :read, :all
    end
  end
end