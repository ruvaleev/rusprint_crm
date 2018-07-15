class CreatePrinterServiceGuides < ActiveRecord::Migration[5.1]
  def change
    create_table :printer_service_guides do |t|
      t.string :model_name, unique: true, index: true
      t.integer :fuser_life_count
      t.string :sheet_size
      t.boolean :color
      t.string :type

    end
  end
end
