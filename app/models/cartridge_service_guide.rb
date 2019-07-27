class CartridgeServiceGuide < ApplicationRecord
  has_and_belongs_to_many :printer_service_guides, join_table: :printers_cartridges
  has_many :order_items, as: :item, inverse_of: :item

  validates :model, :color, :price, :toner_life_count, presence: true
  validates :model, uniqueness: { message: I18n.t('cartridge_service_guides.errors.model_taken_psg') }

  def printers
    printer_service_guides
  end
end
