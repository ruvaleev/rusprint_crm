class CreateOtherOrderItem < ActiveRecord::Migration[5.1]
  def change
    create_table :other_order_items do |t|
      t.string :body
      t.string :price
    end
  end
end
