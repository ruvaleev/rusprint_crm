class PrinterServiceGuide < ApplicationRecord
  has_many :cartridge_service_guide
  
  validates :model, :color, :type, presence: true
end
