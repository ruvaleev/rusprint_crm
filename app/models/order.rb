class Order < ApplicationRecord
  belongs_to :customer, class_name: 'Company', foreign_key: 'customer_id'
  belongs_to :master, class_name: 'User', foreign_key: 'master_id'
  belongs_to :manager, class_name: 'User', foreign_key: 'manager_id'

  has_many :log, as: :registerable

  validates :date_of_order, presence: true
end