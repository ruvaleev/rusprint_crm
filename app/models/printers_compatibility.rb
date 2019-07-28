class PrintersCompatibility < ApplicationRecord
  belongs_to :printer_service_guide
  belongs_to :compatible, polymorphic: true

  validates :printer_service_guide_id, uniqueness: { scope: [:compatible_id, :compatible_type] }
end
