class CreateCartridges < ActiveRecord::Migration[5.1]
  def change
    create_table :cartridges do |t|
      t.string :price_for_customer
      t.string :additional_data
      t.string :masters_note
      
      t.references :cartridge_service_guide

    end
  end
end
