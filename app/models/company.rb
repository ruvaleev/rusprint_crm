class Company < ApplicationRecord
  belongs_to :manager, :class_name => 'User', :foreign_key => 'manager_id'

  has_many :orders, as: :customer
  has_many :employees, :class_name => 'User', :foreign_key => 'employer_id'
  has_many :printers
  has_many :cartridges

  validates :name, presence: true
  validates :adress, presence: true
  validates :telephone, presence: true

  
end