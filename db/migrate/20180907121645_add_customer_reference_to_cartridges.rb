class AddCustomerReferenceToCartridges < ActiveRecord::Migration[5.1]
  def change
    add_reference :cartridges, :company, foreign_key: true 
  end
end
