class AddPrinterReferenceToOrderItems < ActiveRecord::Migration[5.1]
  def change
    add_reference :order_items, :printer, foreign_key: true
  end
end
