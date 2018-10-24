class PrinterServiceGuide < ApplicationRecord
  has_many :cartridge_service_guide
  
  validates :model, :type_of_system, presence: true
end
