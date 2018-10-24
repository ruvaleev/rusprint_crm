class CreateOrderItem < ActiveRecord::Migration[5.1]
  def change
    create_table :order_items do |t|
      t.string :item_type 
      t.references :order
      t.references :item
    end

    add_index :order_items, [:item_id, :item_type]
  end
end
