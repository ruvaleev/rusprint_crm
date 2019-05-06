class ShoppingCart < ApplicationRecord
  acts_as_shopping_cart_using :order_item

  def order_id
    shopping_cart_items.first.try(:order_id)
  end
end
