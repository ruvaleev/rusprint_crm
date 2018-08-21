class AddVendorToPrinterServiceGuides < ActiveRecord::Migration[5.1]
  def change
    add_column :printer_service_guides, :vendor, :string
  end
end