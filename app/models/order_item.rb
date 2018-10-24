class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :item, polymorphic: true, optional: true
  has_many :logs, as: :registerable
end