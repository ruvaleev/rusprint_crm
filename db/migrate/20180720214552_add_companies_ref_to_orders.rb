class AddCompaniesRefToOrders < ActiveRecord::Migration[5.1]
  def change
    add_reference :orders, :customer, foreign_key: { to_table: :companies } 
  end
end
