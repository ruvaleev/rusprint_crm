class PrinterServiceGuide < ApplicationRecord
  has_many :cartridge_service_guide
  
  validates :model, presence: true
  validates :color, presence: true
  validates :type, presence: true
end
