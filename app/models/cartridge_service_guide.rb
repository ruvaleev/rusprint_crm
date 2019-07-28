class CartridgeServiceGuide < ApplicationRecord
  has_many :printers_compatibilities, as: :compatible, inverse_of: :compatible, dependent: :destroy
  has_many :printer_service_guides, as: :compatible, through: :printers_compatibilities
  has_many :order_items, as: :item, inverse_of: :item, dependent: :restrict_with_error

  validates :model, :color, :price, :toner_life_count, presence: true
  validates :model, uniqueness: { case_sensitive: false }

  def printers
    printer_service_guides
  end
end
