class CreatePrintersCartridgesJoinTable < ActiveRecord::Migration[5.1]
  def change
    create_table :printers_cartridges, id: false do |t|
      t.belongs_to :printer_service_guide
      t.belongs_to :cartridge_service_guide
    end
  end
end


