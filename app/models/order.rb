class Order < ApplicationRecord
  belongs_to :customer, class_name: 'Company', foreign_key: 'customer_id'
  belongs_to :master, class_name: 'User', foreign_key: 'master_id', optional: true
  belongs_to :manager, class_name: 'User', foreign_key: 'manager_id', optional: true

  has_many :logs, as: :registerable
  has_many :order_items

  validates :date_of_order, presence: true

end