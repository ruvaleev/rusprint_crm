class Printer < ApplicationRecord
  belongs_to :printer_service_guide
  belongs_to :company
  has_many :log, as: :registerable
  
  validates :printer_service_guide_id, presence: true
end
