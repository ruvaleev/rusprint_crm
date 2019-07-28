class CreatePrintersCompatibilities < ActiveRecord::Migration[5.1]
  def change
    create_table :printers_compatibilities do |t|
      t.belongs_to :printer_service_guide, index: false
      t.references :compatible, polymorphic: true, index: false
    end

    add_index :printers_compatibilities, :printer_service_guide_id
    add_index :printers_compatibilities, :compatible_id
  end
end


