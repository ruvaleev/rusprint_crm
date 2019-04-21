class Printer < ApplicationRecord
  belongs_to :printer_service_guide
  belongs_to :company
  has_many :logs, as: :registerable
  has_many :order_items

  validates :printer_service_guide_id, presence: true

  VENDORS = %w[HP Kyocera Samsung].freeze

  def possible_cartridges
    CartridgeServiceGuide.where(printer_service_guide: printer_service_guide)
  end
end
