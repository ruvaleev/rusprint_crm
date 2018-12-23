class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.datetime :date_of_order
      t.datetime :date_of_complete
      t.datetime :suitable_time_start
      t.datetime :suitable_time_end
      t.string :additional_data
      t.text :printers
      t.text :cartridges
      t.integer :qnt
      t.integer :revenue
      t.integer :expense
      t.integer :profit
      t.references :manager, foreign_key: { to_table: :users }
      t.references :master, foreign_key: { to_table: :users }
    end
  end
end
