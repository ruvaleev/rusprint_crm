class AddDeletedAtToArchiveCompany < ActiveRecord::Migration[5.1]
  def change
    add_column :archive_companies, :deleted_at, :datetime
    add_index :archive_companies, :deleted_at
  end
end
