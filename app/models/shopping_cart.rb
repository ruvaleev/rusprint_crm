class ShoppingCart < ActiveRecord::Base
  acts_as_shopping_cart_using :order_item
end
