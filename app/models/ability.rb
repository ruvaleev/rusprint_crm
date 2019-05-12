class Ability
  include CanCan::Ability

  def initialize(user)
    return if user.nil?

    if user.master?
      can :manage, Order, master_id: user.id
      can :manage, OrderItem, order: { master_id: user.id }
      can :manage, OtherOrderItem do |other_order_item|
        other_order_item.order_item.order.master_id == user.id
      end
      can :manage, User, id: user.id
      can :update, Company
    end

    can :manage, :all               if user.admin?
    can :manage, :all               if user.manager?

    can :read, Order                if user.customer?
    can :manage, User, id: user.id  if user.customer?
  end
end
