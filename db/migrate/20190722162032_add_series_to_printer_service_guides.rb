class AddSeriesToPrinterServiceGuides < ActiveRecord::Migration[5.1]
  def change
    add_column :printer_service_guides, :series, :string
  end
end
