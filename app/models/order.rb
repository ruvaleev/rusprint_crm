class Order < ApplicationRecord
  include AASM
  paginates_per 5

  belongs_to :customer, class_name: 'Company', foreign_key: 'customer_id', inverse_of: :orders
  belongs_to :master, class_name: 'User', foreign_key: 'master_id', optional: true, inverse_of: :orders
  belongs_to :manager, class_name: 'User', foreign_key: 'manager_id', optional: true, inverse_of: :orders

  has_many :logs, as: :registerable, dependent: :destroy, inverse_of: :registerable
  has_many :order_items, dependent: :destroy

  validates :date_of_order, presence: true

  before_save :calculate_profit

  aasm column: 'status' do
    state :pending, initial: true
    state :signed, :completed, :closed, :canceled

    event :sign do
      transitions from: :pending, to: :signed
    end

    event :complete do
      transitions from: :signed, to: :completed
    end

    event :close do
      transitions from: %i[completed canceled], to: :closed, guard: :paid?
    end

    event :cancel do
      transitions from: %i[pending signed completed closed], to: :canceled
    end
  end

  PROVIDERS = %w[RusPrint MetroPrint].freeze

  def calculate_profit
    self.profit = (revenue || 0) - (expense || 0)
  end

  def self.prohibited_params(current_user)
    if current_user.admin?
      permitted_params = column_names
    elsif current_user.manager?
      permitted_params = column_names
    elsif current_user.master?
      # Параметры, которые разрешено редактировать юзеру
      permitted_params = %w[date_of_complete additional_data printers cartridges qnt
                            revenue status expense customer_id]
    end
    column_names - permitted_params.to_a
  end
end
