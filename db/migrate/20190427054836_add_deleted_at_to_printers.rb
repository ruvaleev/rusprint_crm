class AddDeletedAtToPrinters < ActiveRecord::Migration[5.1]
  def change
    add_column :printers, :deleted_at, :datetime
    add_index :printers, :deleted_at
  end
end
