class CreateArchiveCompanies < ActiveRecord::Migration[5.1]
  def change
    create_table :archive_companies do |t|
      t.string :name
      t.string :adress, index: true
      t.string :telephone
      t.string :email
      t.string :version

      t.references :user, foreign_key: true 
      t.references :company, foreign_key: true
    end

    add_column :companies, :version, :integer
  end
end
