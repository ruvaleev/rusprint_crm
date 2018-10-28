class OrderItem < ApplicationRecord
  belongs_to :order, required: false
  # has_many :logs, as: :registerable
  acts_as_shopping_cart_item_for :shopping_cart
  belongs_to :item, polymorphic: true, required: false

end