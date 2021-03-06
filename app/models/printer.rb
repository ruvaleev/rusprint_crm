class Printer < ApplicationRecord
  acts_as_paranoid
  belongs_to :printer_service_guide
  belongs_to :company
  has_many :logs, as: :registerable, inverse_of: :registerable
  has_many :order_items, dependent: :nullify

  validates :printer_service_guide_id, presence: true

  # Записываем Вендоры только маленькими буквами
  VENDORS = %w[hp kyocera samsung].freeze

  def possible_cartridges
    printer_service_guide.cartridges
  end
end
