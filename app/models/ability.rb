class Ability
  include CanCan::Ability

  def initialize(user)
    can :manage, :all if user.admin?

    if user.master?
      can :manage, Order, master_id: user.id
      can :manage, User, id: user.id
      can :manage, Company
    end

    if user.manager?
      can :manage, :all
    end
  end
end
