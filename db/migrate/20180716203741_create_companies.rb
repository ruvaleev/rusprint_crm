class CreateCompanies < ActiveRecord::Migration[5.1]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :adress, index: true
      t.string :telephone
      t.string :email

      t.references :manager, foreign_key: { to_table: :users }
    end

  end

end