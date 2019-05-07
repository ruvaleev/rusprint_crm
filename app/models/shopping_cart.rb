class ShoppingCart < ApplicationRecord
  acts_as_shopping_cart_using :order_item
  has_one :order
end
