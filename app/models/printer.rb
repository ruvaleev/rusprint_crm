class Printer < ApplicationRecord
  belongs_to :printer_service_guide
  belongs_to :company
  has_many :log, as: :registerable
  
  validates :printer_service_guide_id, presence: true
  
  VENDORS = ['HP', 'Kyocera', 'Samsung']

  def possible_cartridges
    CartridgeServiceGuide.where(printer_service_guide: self.printer_service_guide)
  end
end
