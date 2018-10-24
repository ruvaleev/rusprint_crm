class Cartridge < ApplicationRecord
  belongs_to :cartridge_service_guide
  belongs_to :company
  has_many :logs, as: :registerable
end