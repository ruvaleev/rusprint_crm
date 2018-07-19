class CreateCartridgeServiceGuides < ActiveRecord::Migration[5.1]
  def change
    create_table :cartridge_service_guides do |t|
      t.string :model, unique: true, index: true
      t.integer :toner_life_count
      t.string :price_for_refill
      t.string :color

      t.references :printer_service_guide
    end
  end
end
