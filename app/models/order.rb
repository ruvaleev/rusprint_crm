class Order < ApplicationRecord
  belongs_to :customer, :class_name => 'Company', :foreign_key => 'customer_id'
  belongs_to :master, :class_name => 'User', :foreign_key => 'master_id'

  has_many :cartridges
  has_many :printers
  has_many :log, as: :registerable
  
  validates :printer_service_guide_id, presence: true
end