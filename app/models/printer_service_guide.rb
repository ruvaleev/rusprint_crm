class PrinterServiceGuide < ApplicationRecord
  has_many :printers_compatibilities, dependent: :destroy
  has_many :cartridges, through: :printers_compatibilities, source: :compatible, source_type: 'CartridgeServiceGuide'
  validates :model, :type_of_system, presence: true
  validates :model, uniqueness: { case_sensitive: false, scope: :vendor }
end
