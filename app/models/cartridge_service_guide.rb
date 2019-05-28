class CartridgeServiceGuide < ApplicationRecord
  belongs_to :printer_service_guide
  has_many :order_items, as: :item

  validates :model, :color, :price, :toner_life_count, presence: true
  validates :model, uniqueness: { scope: :printer_service_guide_id,
                                  message: I18n.t('cartridge_service_guides.errors.model_taken_psg') }
end
