class AddProviderToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :provider, :string, default: 'RusPrint'
  end
end
