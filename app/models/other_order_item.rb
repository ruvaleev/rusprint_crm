class OtherOrderItem < ApplicationRecord
  has_one :order_item, as: :item, dependent: :destroy
  validates :body, presence: true
  validates :price, presence: true
end
