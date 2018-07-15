class CreatePrinters < ActiveRecord::Migration[5.1]
  def change
    create_table :printers do |t|
      t.string :serial_number, unique: true
      t.integer :fuser_life_count
      t.string :additional_data
      t.string :masters_note
      
      t.references :printer_service_guide

    end
  end
end
