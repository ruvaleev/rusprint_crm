class AddCustomerReferenceToPrinters < ActiveRecord::Migration[5.1]
  def change
    add_reference :printers, :company, foreign_key: true
  end
end
