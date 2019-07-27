class PrinterServiceGuide < ApplicationRecord
  has_and_belongs_to_many :cartridge_service_guides, join_table: :printers_cartridges

  validates :model, :type_of_system, presence: true

  def cartridges
    cartridge_service_guides
  end
end
