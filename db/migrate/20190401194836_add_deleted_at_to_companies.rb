class AddDeletedAtToCompanies < ActiveRecord::Migration[5.1]
  def change
    add_column :companies, :deleted_at, :datetime
    add_index :companies, :deleted_at
  end
end
