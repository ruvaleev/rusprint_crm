class OrderItem < ApplicationRecord
  belongs_to :order, optional: true
  # has_many :logs, as: :registerable
  acts_as_shopping_cart_item_for :shopping_cart
  belongs_to :item, polymorphic: true, optional: true
  belongs_to :printer, optional: true

  def without_cents
    price_cents / 100
  end
end
