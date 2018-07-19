class CartridgeServiceGuide < ApplicationRecord
  belongs_to :printer_service_guide
  
  validates :model, presence: true
  validates :color, presence: true
  validates :price_for_refill, presence: true
  validates :toner_life_count, presence: true
end
