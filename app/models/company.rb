class Company < ApplicationRecord
  belongs_to :manager, class_name: 'User', foreign_key: 'manager_id', optional: true

  has_many :orders, as: :customer
  has_many :employees, class_name: 'User', foreign_key: 'employer_id', dependent: :nullify
  has_many :printers
  # has_many :cartridges

  validates :name, :adress, :telephone, presence: true

  
end