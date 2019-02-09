class Order < ApplicationRecord
  belongs_to :customer, class_name: 'Company', foreign_key: 'customer_id'
  belongs_to :master, class_name: 'User', foreign_key: 'master_id', optional: true
  belongs_to :manager, class_name: 'User', foreign_key: 'manager_id', optional: true

  has_many :logs, as: :registerable
  has_many :order_items

  validates :date_of_order, presence: true

  before_save :calculate_profit

  def calculate_profit
    self.profit = revenue - (expense || 0)
  end

  def self.prohibited_params(current_user)
    case 
    when current_user.master?
      # Параметры, которые разрешено редактировать юзеру
      permitted_params = [ "date_of_complete", "additional_data", "printers", "cartridges", "qnt", "revenue", "expense", "master_id", "customer_id"]
    end
    self.column_names - permitted_params
  end

end