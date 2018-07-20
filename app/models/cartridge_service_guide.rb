class CartridgeServiceGuide < ApplicationRecord
  belongs_to :printer_service_guide
  
  validates :model, :color, :price_for_refill, :toner_life_count, presence: true
end
