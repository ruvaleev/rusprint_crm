class Printer < ApplicationRecord
  belongs_to :printer_service_guide
  has_many :log, as: :registerable
  
  validates :printer_service_guide_id, presence: true
end
