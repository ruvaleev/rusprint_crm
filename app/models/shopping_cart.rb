class ShoppingCart < ApplicationRecord
  acts_as_shopping_cart_using :order_item
  has_one :order

  def cartridge_order_items
    shopping_cart_items.where(item_type: 'CartridgeServiceGuide')
  end

  def other_order_items
    shopping_cart_items.where(item_type: 'OtherOrderItem')
  end
end
