class OtherOrderItem < ApplicationRecord
  has_many :order_items, as: :item
  validates :body, presence: true
end
