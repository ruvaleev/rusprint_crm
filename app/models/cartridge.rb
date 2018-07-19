class Cartridge < ApplicationRecord
  belongs_to :cartridge_service_guide
  has_many :log, as: :registerable
  
end