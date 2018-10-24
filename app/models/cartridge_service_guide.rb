class CartridgeServiceGuide < ApplicationRecord
  belongs_to :printer_service_guide
  has_many :order_items, as: :item
  
  validates :model, :color, :price_for_refill, :toner_life_count, presence: true
end
